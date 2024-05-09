1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10 
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 contract ERC20Basic {
45 
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 
51 }
52 
53 
54 contract GanaToken is ERC20Basic {
55 
56   function saleTransfer(address to, uint256 value) public returns (bool);
57 
58 }
59 
60 
61 /**
62   * GanaTokenAirdropper
63   */
64 contract GanaTokenAirdropper is Ownable {
65 
66   GanaToken gana;
67 
68   event ClaimedGanaTokens();
69   event ClaimedTokens(address _token, uint256 claimedBalance);
70 
71   function GanaTokenAirdropper(address _gana) public{
72     gana = GanaToken(_gana);
73   }
74 
75   function airdrop(address[] _addrs, uint256[] _values) public onlyOwner {
76     require(_addrs.length == _values.length);
77 
78     for(uint256 i = 0; i < _addrs.length; i++) {
79       require(gana.saleTransfer(_addrs[i], _values[i]));
80     }
81   }
82 
83   function claimGanaTokens() public onlyOwner {
84     uint256 ganaBalance = gana.balanceOf(this);
85     require(ganaBalance >= 0);
86 
87     gana.saleTransfer(owner, ganaBalance);
88     emit ClaimedGanaTokens();
89   }
90 
91   function claimTokens(address _token) public onlyOwner {
92     ERC20Basic token = ERC20Basic(_token);
93     uint256 tokenBalance = token.balanceOf(this);
94     require(tokenBalance >= 0);
95 
96     token.transfer(owner, tokenBalance);
97     emit ClaimedTokens(_token, tokenBalance);
98   }
99 
100   function ganaBalance() public view returns (uint256){
101     return gana.balanceOf(this);
102   }
103 
104 }