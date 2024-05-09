1 pragma solidity ^0.4.13;
2 
3 contract ERC20Interface {
4   function totalSupply() constant returns (uint256 totalSupply);
5   function balanceOf(address _owner) constant returns (uint256 balance);
6   function transfer(address _to, uint256 _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8   function approve(address _spender, uint256 _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10   event Transfer(address indexed _from, address indexed _to, uint256 _value);
11   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract ViewCoin is ERC20Interface {
15   string public constant symbol = "VJU";
16   string public constant name = "ViewCoin";
17   uint8 public constant decimals = 0;
18   uint256 _totalSupply = 100000000;
19   uint256 public maxSell = 50000000;
20   uint256 public totalSold = 0;
21   uint256 public buyPrice = 5 szabo;
22   uint256 public minPrice = 5 szabo;
23   address public owner;
24   mapping(address => uint256) balances;
25   mapping(address => mapping (address => uint256)) allowed;
26   modifier onlyOwner() {
27     if (msg.sender != owner) {revert();}
28     _;
29   }
30   
31   function ViewCoin() {
32     owner = msg.sender;
33     balances[owner] = _totalSupply;
34   }
35    
36   function totalSupply() constant returns (uint256 totalSupply) {
37     totalSupply = _totalSupply;
38   }
39    
40   function balanceOf(address _owner) constant returns (uint256 balance) {
41     return balances[_owner];
42   }
43    
44   function transfer(address _to, uint256 _amount) returns (bool success) {
45     if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
46       balances[msg.sender] -= _amount;
47       balances[_to] += _amount;
48       Transfer(msg.sender, _to, _amount);
49       return true;
50     } else {return false;}
51   }
52    
53   function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {
54     if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
55       balances[_from] -= _amount;
56        allowed[_from][msg.sender] -= _amount;
57        balances[_to] += _amount;
58        Transfer(_from, _to, _amount);
59        return true;
60     } else {return false;}
61   }
62   
63   function approve(address _spender, uint256 _amount) returns (bool success) {
64     allowed[msg.sender][_spender] = _amount;
65     Approval(msg.sender, _spender, _amount);
66     return true;
67   }
68   
69   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70     return allowed[_owner][_spender];
71   }
72   
73   function setPrices(uint256 newBuyPrice) onlyOwner {
74         if (newBuyPrice<minPrice) revert();
75         buyPrice = newBuyPrice*1 szabo;
76     }
77 
78   function () payable {
79     uint amount = msg.value / buyPrice;
80     if (totalSold>=maxSell || balances[this] < amount) revert(); 
81     balances[msg.sender] += amount;
82     balances[this] -= amount;
83     totalSold += amount; 
84     Transfer(this, msg.sender, amount);
85     if (!owner.send(msg.value)) revert();
86   }
87    
88 }