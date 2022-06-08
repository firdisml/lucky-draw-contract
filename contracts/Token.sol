// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Stakeable.sol";
import "./Draw.sol";

contract Token is
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    Stakeable,
    Draw
{
    function initialize() external initializer {
        __ERC20_init("RAIZZEN", "RZN");
        __Ownable_init();
        __Stakeable_init();
        __Draw_init();
    }

    //ERC20-UPGRADEABLE

    function mint(uint256 _amount) external onlyOwner {
        _mint(msg.sender, _amount);
    }

    //STAKEABLE

    function setRate(uint256 _amount) external onlyOwner {
        _setRate(_amount);
    }

    function getRate() external view returns (uint256) {
        return _getRate();
    }

    function withdrawStake(uint256 _amount, uint256 _stake_index) external {
        uint256 total_withdraw = _withdrawStake(_amount, _stake_index);
        _mint(msg.sender, total_withdraw);
    }

    function redeem(uint256 _amount) public {
        require(
            _amount <= balanceOf(msg.sender),
            "Raizzen Token: Cannot redeem more than you own"
        );

        _burn(msg.sender, _amount);
    }

    function stake(uint256 _amount) external {
        require(
            _amount <= balanceOf(msg.sender),
            "Raizzen Token: Cannot stake more than you own"
        );

        require(
            hasStake(msg.sender).total_amount == 0,
            "Function Authorization: Stake Exists"
        );

        _stake(_amount);

        _burn(msg.sender, _amount);
    }

    //DRAW

    function setPrize(uint256 _amount) external onlyOwner {
        _setPrize(_amount);
    }

    function setRequirement(uint256 _amount) external onlyOwner {
        _setRequirement(_amount);
    }

    function getPrize() external view returns (uint256) {
        return _getPrize();
    }

    function getParticipants() external view returns (address[] memory) {
        return _getParticipants();
    }

    function getWinner(uint256 _drawID) external view returns (address) {
        return _getWinner(_drawID);
    }

    function getdrawID() external view returns (uint256) {
        return _getdrawID();
    }

    function getRequirement() external view returns (uint256) {
        return _getRequirement();
    }

    function enterDraw() public {
        require(
            _getRequirement() <= balanceOf(msg.sender),
            "Raizzen Token: Balance is not enough"
        );

        _enterDraw(msg.sender);

        _burn(msg.sender, _getRequirement());
    }

    function pickWinner(uint256 _randomNumber) public onlyOwner {
        _mint(_pickWinner(_randomNumber), _getPrize());
        _resetDraw();
    }
}
