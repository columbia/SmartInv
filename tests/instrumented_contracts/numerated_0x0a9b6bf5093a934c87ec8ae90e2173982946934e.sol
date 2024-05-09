1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4   function totalSupply() constant returns (uint totalsupply);
5   function balanceOf(address _owner) constant returns (uint balance);
6   function transfer(address _to, uint _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint _value) returns (bool success);
8   function approve(address _spender, uint _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint remaining);
10   event Transfer(address indexed _from, address indexed _to, uint _value);
11   event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract Owned {
15   address public owner;
16   event OwnershipTransferred(address indexed _from, address indexed _to);
17 
18   function Owned() {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner {
23     if (msg.sender != owner) revert();
24     _;
25   }
26 
27   function transferOwnership(address newOwner) onlyOwner {
28     OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 }
32 
33 contract GetToken is Owned {
34   address public token;
35   uint256 public sellPrice;
36 	
37   event GotTokens(address indexed buyer, uint256 ethersSent, uint256 tokensBought);
38 	
39   function GetToken (
40     address _token,
41     uint256 _sellPrice
42   ) {
43     token = _token;
44     sellPrice = _sellPrice * 1 szabo;
45   }
46     
47   function WithdrawToken(uint256 tokens) onlyOwner returns (bool ok) {
48     return ERC20(token).transfer(owner, tokens);
49   }
50     
51   function SetPrice (uint256 newprice) onlyOwner {
52     sellPrice = newprice * 1 szabo;
53   }
54     
55   function WithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {
56     if (this.balance >= ethers) {
57       return owner.send(ethers);
58     }
59   }
60     
61   function BuyToken() payable {
62     uint tokens = msg.value / sellPrice;
63     uint total = ERC20(token).balanceOf(address(this));
64     uint256 change = 0;
65     uint256 maxethers = total * sellPrice;
66     if (msg.value > maxethers) {
67       change  = msg.value - maxethers;
68     }
69     if (change > 0) {
70       if (!msg.sender.send(change)) revert();
71     }
72     if (tokens > 0) {
73       if (!ERC20(token).transfer(msg.sender, tokens)) revert();
74     }
75     GotTokens(msg.sender, msg.value, tokens);
76   }
77     
78   function () payable {
79     BuyToken();
80   }
81 }