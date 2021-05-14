// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Pour remix il faut importer une url depuis un repository github
// Depuis un project Hardhat ou Truffle on utiliserait: import "@openzeppelin/ccontracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
import "./Ownable.sol";

contract Testament is Ownable {
    using Address for address payable;

    mapping(address => uint256) private _beneficiaries;
    //address private _owner;
    address private _doctor;
    bool private _isDead = false;
    
    event Bequeathed(address indexed heir, uint256 amount);
    event Inherited(address indexed heir, uint256 amount); 

    constructor(address owner_, address doctor_) Ownable(owner_) {
        _doctor = doctor_;
    }


    receive() external payable {
        require(1 == 2, "You cannot send ether directly to this smart-contract, use bequeath instead");
    }

    fallback() external {}
    
    function getLegacy() external {
        require(_isDead == true, "Testament (getLegacy) : The owner is not dead");
        uint256 tmp = _beneficiaries[msg.sender];
        _beneficiaries[msg.sender] = 0;
        emit Inherited(msg.sender, tmp);
        payable(msg.sender).sendValue(tmp);
    }
    
    function legacy(address beneficiary) public view returns (uint256) {
        return _beneficiaries[beneficiary];
    }

    function bequeath(address account) public payable onlyOwner {
	require(account != 0, "Testament : You cannot bequeath to address 0");
        emit Bequeathed(account, msg.value);
        _beneficiaries[account] += msg.value;
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function doctor() public view returns (address) {
        return _doctor;
    }
    
    function setDoctor(address newDoctor) public onlyOwner {
        _doctor = newDoctor;
    }
    
    function declareDeath() external {
        require(msg.sender == _doctor, "Ownable: Only doctor can call this function");
        _isDead = true;
    }
}
