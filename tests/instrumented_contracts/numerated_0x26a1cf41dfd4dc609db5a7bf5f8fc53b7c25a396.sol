1 pragma solidity ^0.4.18;
2 
3 contract Owner {
4     address public owner;
5     modifier onlyOwner { require(msg.sender == owner); _;}
6     function Owner() public { owner = msg.sender; }
7 }
8 
9 contract ERC20Basic{
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event onTransfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /* contract ERC20 is ERC20Basic {
17   function allowance(address owner, address spender) public constant returns (uint256);
18   function transferFrom(address from, address to, uint256 value) public returns (bool);
19   function approve(address spender, uint256 value) public returns (bool);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 } */
22 
23 contract LajoinCoin is ERC20Basic, Owner {
24 
25   string public name;
26   string public symbol;
27   uint8 public decimals;
28   mapping(address => uint256) balances;
29 
30   struct FrozenToken {
31     bool isFrozenAll;
32     uint256 amount;
33     uint256 unfrozenDate;
34   }
35   mapping(address => FrozenToken) frozenTokens;
36 
37   event onFrozenAccount(address target,bool freeze);
38   event onFrozenToken(address target,uint256 amount,uint256 unforzenDate);
39 
40   function LajoinCoin(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 decimalUnits) public {
41     balances[msg.sender] = initialSupply;
42     totalSupply = initialSupply;
43     name = tokenName;
44     decimals = decimalUnits;
45     symbol = tokenSymbol;
46   }
47 
48   function changeOwner(address newOwner) onlyOwner public {
49     balances[newOwner] += balances[msg.sender];
50     balances[msg.sender] = 0;
51     owner = newOwner;
52   }
53 
54   function freezeAccount(address target,bool freeze) onlyOwner public {
55       frozenTokens[target].isFrozenAll = freeze;
56       onFrozenAccount(target, freeze);
57   }
58 
59   function freezeToken(address target,uint256 amount,uint256 date)  onlyOwner public {
60       require(amount > 0);
61       require(date > now);
62       frozenTokens[target].amount = amount;
63       frozenTokens[target].unfrozenDate = date;
64 
65       onFrozenToken(target,amount,date);
66   }
67 
68   function transfer(address to,uint256 value) public returns (bool) {
69     require(msg.sender != to);
70     require(value > 0);
71     require(balances[msg.sender] >= value);
72     require(frozenTokens[msg.sender].isFrozenAll != true);
73 
74     if(frozenTokens[msg.sender].unfrozenDate > now){
75         require(balances[msg.sender] - value >= frozenTokens[msg.sender].amount);
76     }
77 
78     balances[msg.sender] -= value;
79     balances[to] += value;
80     onTransfer(msg.sender,to,value);
81 
82     return true;
83   }
84 
85   function balanceOf(address addr) public constant returns (uint256) {
86     return balances[addr];
87   }
88 
89   function kill() public {
90     if(owner == msg.sender){
91         selfdestruct(owner);
92     }
93   }
94 }