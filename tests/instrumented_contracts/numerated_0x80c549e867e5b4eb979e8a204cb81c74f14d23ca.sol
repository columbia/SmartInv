1 pragma solidity ^0.5.16;
2 
3 contract ERC20Basic {
4 
5     function balanceOf(address tokenOwner) external view returns (uint balance);
6     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
7     function approve(address spender, uint tokens) external returns (bool success);
8 
9     function transfer(address to, uint tokens) external returns (bool success);
10     function transferFrom(address from, address to, uint tokens) external returns (bool success);
11     
12     function setTotalSupply(uint256 _value) public returns (uint totalSupply);
13     
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 contract MyERC20 is ERC20Basic {
19 
20     string public  name;
21     string public  symbol;
22     uint8 public constant decimals = 18;
23     uint public totalSupply;
24     mapping(address => uint256) internal _balances;
25     mapping(address => mapping(address => uint256)) allowed;
26 
27     constructor(string memory _name, string memory _symbol, uint256 _initialSupply) public {
28        name = _name;
29        symbol = _symbol;
30        totalSupply = setTotalSupply(_initialSupply);
31        _balances[msg.sender] = totalSupply;
32     }
33 
34     function setTotalSupply(uint256 _value) public returns (uint total) {
35         return _value * 10 ** uint256(decimals);
36     }
37     
38     function balanceOf(address tokenOwner) public view returns (uint balance) {
39         return _balances[tokenOwner];
40     }
41 
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
43         return allowed[_owner][_spender];
44     }
45 
46   
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48         require(_to != address(0));
49         require(allowed[_from][msg.sender] >= _value);
50         require(_balances[_from] >= _value);
51         require(_balances[ _to] + _value >= _balances[ _to]);
52         _balances[_from] -= _value;
53         _balances[_to] += _value;
54         allowed[_from][msg.sender] -= _value;
55         emit Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function transfer(address _to, uint256 _value)  public returns (bool success) {
60         require(_to != address(0));
61         require(_balances[msg.sender] >= _value);
62         require(_balances[ _to] + _value >= _balances[ _to]);
63         _balances[msg.sender] -= _value;
64         _balances[_to] += _value;
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) public returns (bool success) {
70       allowed[msg.sender][_spender] = _value;
71       emit Approval(msg.sender, _spender, _value);
72       return true;
73     }
74 
75 }