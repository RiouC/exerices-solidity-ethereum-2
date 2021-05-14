// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Pour remix il faut importer une url depuis un repository github
// Depuis un project Hardhat ou Truffle on utiliserait: import "@openzeppelin/ccontracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
//import "./Ownable.sol";

contract Birthday {
    using Address for address payable;

    address private _presentReceiver;
    uint256 private _giftAmount;
    uint256 private _timestampOrigin;
    uint256 private _birthdayDate;

    event Offered(address indexed sender, uint256 amount);
    event Given(address indexed presentReceiver, uint256 amount);

    constructor(address presentReceiver_, uint256 daysDelay) {
        _presentReceiver = presentReceiver_;
        _timestampOrigin = block.timestamp;
        _birthdayDate = _timestampOrigin + daysDelay * 1 days;
    }


    receive() external payable {
        _giftAmount += msg.value;
	emit Offered(msg.sender, msg.value);
    }

    fallback() external {}
    
    function offer() external payable {
        _giftAmount += msg.value;
	emit Offered(msg.sender, msg.value);
    }
    
    function getPresent() external {
        require(msg.sender == _presentReceiver, "Birthday (getPresent) : You cannot withdraw because it is not YOUR birthday");
        require(block.timestamp + 1 days >= _birthdayDate, "Birthday (getPresent) : This is not yet your birthday, be patient !");
        uint256 tmp = _giftAmount;
        _giftAmount = 0;
	emit Given(_presentReceiver, _giftAmount);
        payable(msg.sender).sendValue(tmp);
    }
    
    function giftAmount() public view returns (uint256) {
        return _giftAmount;
    }
    
    function timestampOrigin() public view returns (uint256) {
        return _timestampOrigin;
    }
    
    function currentTimestamp() public view returns (uint256) {
        return block.timestamp;
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
