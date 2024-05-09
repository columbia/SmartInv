1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, March 5, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 contract ERC20Basic {}
8 contract ERC20 is ERC20Basic {}
9 contract Ownable {}
10 contract BasicToken is ERC20Basic {}
11 contract StandardToken is ERC20, BasicToken {}
12 contract Pausable is Ownable {}
13 contract PausableToken is StandardToken, Pausable {}
14 contract MintableToken is StandardToken, Ownable {}
15 
16 contract PDataToken is MintableToken, PausableToken {
17   mapping(address => uint256) balances;
18   function transfer(address _to, uint256 _value) public returns (bool);
19   function balanceOf(address who) public view returns (uint256);
20 }
21 
22 contract SVPContract {
23   //storage
24   address public owner;
25   PDataToken public saved_token;
26 
27   //modifiers
28   modifier onlyOwner
29   {
30     require(owner == msg.sender);
31     _;
32   }
33   
34   
35   //Events
36   event Transfer(address indexed to, uint indexed value);
37   event OwnerChanged(address indexed owner);
38 
39 
40   //constructor
41   constructor (PDataToken _company_token) public {
42     owner = msg.sender;
43     saved_token = _company_token;
44   }
45 
46 
47   /// @dev Fallback function: don't accept ETH
48   function()
49     public
50     payable
51   {
52     revert();
53   }
54 
55   function setOwner(address _owner) 
56     public 
57     onlyOwner 
58   {
59     require(_owner != 0);
60     
61     owner = _owner;
62     emit OwnerChanged(owner);
63   }
64   
65   function sendPayment(uint256 amount, address final_account) 
66   public 
67   onlyOwner {
68     saved_token.transfer(final_account, amount);
69     emit Transfer(final_account, amount);
70   }
71 }