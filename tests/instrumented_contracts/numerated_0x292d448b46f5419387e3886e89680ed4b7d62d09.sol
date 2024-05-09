1 pragma solidity ^0.4.15;
2 
3 contract AbstractMintableToken {
4     function mintFromTrustedContract(address _to, uint256 _amount) returns (bool);
5 }
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) onlyOwner {
39         if (newOwner != address(0)) {
40             owner = newOwner;
41         }
42     }
43 
44 }
45 
46 contract RegistrationBonus is Ownable {
47     address public tokenAddr;
48     uint256 constant  bonusAmount = 1 * 1 ether;
49     mapping (address => uint) public beneficiaryAddresses;
50     mapping (uint => address) public beneficiaryUserIds;
51     AbstractMintableToken token;
52 
53     event BonusEnrolled(address beneficiary, uint userId, uint256 amount);
54 
55     function RegistrationBonus(address _token){
56         tokenAddr = _token;
57         token = AbstractMintableToken(tokenAddr);
58     }
59 
60     function addBonusToken(address _beneficiary, uint _userId) onlyOwner returns (bool) {
61         require(beneficiaryAddresses[_beneficiary] == 0);
62         require(beneficiaryUserIds[_userId] == 0);
63 
64         if(token.mintFromTrustedContract(_beneficiary, bonusAmount)) {
65             beneficiaryAddresses[_beneficiary] = _userId;
66             beneficiaryUserIds[_userId] = _beneficiary;
67             BonusEnrolled(_beneficiary, _userId, bonusAmount);
68             return true;
69         } else {
70             return false;
71         }
72     }
73 }