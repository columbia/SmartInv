1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin-solidity-1.4/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/BRDCrowdsaleAuthorizer.sol
48 
49 /**
50  * Contract BRDCrowdsaleAuthorizer is used by the crowdsale website
51  * to autorize wallets to participate in the crowdsale. Because all
52  * participants must go through the KYC/AML phase, only accounts
53  * listed in this contract may contribute to the crowdsale
54  */
55 contract BRDCrowdsaleAuthorizer is Ownable {
56   // these accounts are authorized to participate in the crowdsale
57   mapping (address => bool) internal authorizedAccounts;
58   // these accounts are authorized to authorize accounts
59   mapping (address => bool) internal authorizers;
60 
61   // emitted when a new account is authorized
62   event Authorized(address indexed _to);
63 
64   // add an authorizer to the authorizers mapping. the _newAuthorizer will
65   // be able to add other authorizers and authorize crowdsale participants
66   function addAuthorizer(address _newAuthorizer) onlyOwnerOrAuthorizer public {
67     // allow the provided address to authorize accounts
68     authorizers[_newAuthorizer] = true;
69   }
70 
71   // remove an authorizer from the authorizers mapping. the _bannedAuthorizer will
72   // no longer have permission to do anything on this contract
73   function removeAuthorizer(address _bannedAuthorizer) onlyOwnerOrAuthorizer public {
74     // only attempt to remove the authorizer if they are currently authorized
75     require(authorizers[_bannedAuthorizer]);
76     // remove the authorizer
77     delete authorizers[_bannedAuthorizer];
78   }
79 
80   // allow an account to participate in the crowdsale
81   function authorizeAccount(address _newAccount) onlyOwnerOrAuthorizer public {
82     if (!authorizedAccounts[_newAccount]) {
83       // allow the provided account to participate in the crowdsale
84       authorizedAccounts[_newAccount] = true;
85       // emit the Authorized event
86       Authorized(_newAccount);
87     }
88   }
89 
90   // returns whether or not the provided _account is an authorizer
91   function isAuthorizer(address _account) constant public returns (bool _isAuthorizer) {
92     return msg.sender == owner || authorizers[_account] == true;
93   }
94 
95   // returns whether or not the provided _account is authorized to participate in the crowdsale
96   function isAuthorized(address _account) constant public returns (bool _authorized) {
97     return authorizedAccounts[_account] == true;
98   }
99 
100   // allow only the contract creator or one of the authorizers to do this
101   modifier onlyOwnerOrAuthorizer() {
102     require(msg.sender == owner || authorizers[msg.sender]);
103     _;
104   }
105 }