1 pragma solidity ^0.4.13;
2 
3 contract ERC20Interface {
4   function totalSupply() constant public returns (uint256 supply);
5   function balanceOf(address _owner) constant public returns (uint256 balance);
6   function transfer(address _to, uint256 _value) public returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8   function approve(address _spender, uint256 _value) public returns (bool success);
9   function allowance(address _owner, address _spender) public returns (uint256 remaining);
10   event Transfer(address indexed _from, address indexed _to, uint256 _value);
11   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract KiCoin is ERC20Interface {
15   string public constant symbol = "KIC";
16   string public constant name = "KiCoin";
17   uint8 public constant decimals = 2;
18   uint256 _totalSupply = 245000000;
19   address public owner;
20   mapping(address => uint256) balances;
21   mapping(address => mapping (address => uint256)) allowed;
22   modifier onlyOwner() {
23     if (msg.sender != owner) {revert();}
24     _;
25   }
26   
27   function KiCoin() public {
28     owner = msg.sender;
29     balances[owner] = _totalSupply;
30   }
31   
32   function transferOwnership(address newOwner) public onlyOwner {owner = newOwner;}
33   
34   function totalSupply() constant public returns (uint256 supply) {
35     supply = _totalSupply;
36   }
37    
38   function balanceOf(address _owner) constant public returns (uint256 balance) {
39     return balances[_owner];
40   }
41    
42   function transfer(address _to, uint256 _amount) public returns (bool success) {
43     if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
44       balances[msg.sender] -= _amount;
45       balances[_to] += _amount;
46       Transfer(msg.sender, _to, _amount);
47       return true;
48     } else {return false;}
49   }
50    
51   function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {
52     if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
53       balances[_from] -= _amount;
54        allowed[_from][msg.sender] -= _amount;
55        balances[_to] += _amount;
56        Transfer(_from, _to, _amount);
57        return true;
58     } else {return false;}
59   }
60   
61   function approve(address _spender, uint256 _amount) public returns (bool success) {
62     allowed[msg.sender][_spender] = _amount;
63     Approval(msg.sender, _spender, _amount);
64     return true;
65   }
66   
67   function allowance(address _owner, address _spender) public returns (uint256 remaining) {
68     return allowed[_owner][_spender];
69   }
70 
71   function () external {
72     revert();
73   }
74    
75 }