1 pragma solidity ^0.4.18;
2 
3 contract CyberShekel {
4 
5   uint8 Decimals = 0;
6   uint256 total_supply = 1000000000000;
7   address owner;
8 
9   function CyberShekel() public{
10     owner = msg.sender;
11     balanceOf[msg.sender] = total_supply;
12   }
13 
14   event Transfer(address indexed _from, address indexed _to, uint256 value);
15   event Approval(address indexed _owner, address indexed _spender, uint256 value);
16 
17   mapping (address => uint256) public balanceOf;
18   mapping (address => mapping (address => uint)) public allowance;
19 
20 
21   function name() pure public returns (string _name){
22     return "CyberShekel";
23   }
24 
25   function symbol() pure public returns (string _symbol){
26     return "CSK";
27   }
28 
29   function decimals() view public returns (uint8 _decimals){
30     return Decimals;
31   }
32 
33   function totalSupply() public constant returns (uint256 total){
34       return total_supply;
35   }
36 
37   function balanceOf(address tokenOwner) public constant returns (uint256 balance){
38     return balanceOf[tokenOwner];
39   }
40 
41   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining){
42     return allowance[tokenOwner][spender];
43   }
44 
45   function transfer(address recipient, uint256 value) public returns (bool success){
46     require(balanceOf[msg.sender] >= value);
47     require(balanceOf[recipient] + value >= balanceOf[recipient]);
48     balanceOf[msg.sender] -= value;
49     balanceOf[recipient] += value;
50     Transfer(msg.sender, recipient, value);
51 
52     return true;
53   }
54 
55   function approve(address spender, uint256 value) public returns (bool success){
56     allowance[msg.sender][spender] = value;
57     Approval(msg.sender, spender, value);
58     return true;
59   }
60 
61   function transferFrom(address from, address recipient, uint256 value) public
62       returns (bool success){
63     require(balanceOf[from] >= value);                                          //ensure from address has available balance
64     require(balanceOf[recipient] + value >= balanceOf[recipient]);              //stop overflow
65     require(value <= allowance[from][msg.sender]);                              //ensure msg.sender has enough allowance
66     balanceOf[from] -= value;
67     balanceOf[recipient] += value;
68     allowance[from][msg.sender] -= value;
69     Transfer(from, recipient, value);
70 
71     return true;
72   }
73   
74 }