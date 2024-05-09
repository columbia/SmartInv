1 pragma solidity ^0.4.21;
2 
3 contract CoinBundleToken {
4 
5   function add(uint256 x, uint256 y) pure internal returns (uint256 z) { assert((z = x + y) >= x); }
6   function sub(uint256 x, uint256 y) pure internal returns (uint256 z) { assert((z = x - y) <= x); }
7 
8   event Transfer(address indexed from, address indexed to, uint256 value);
9   event Approval(address indexed owner, address indexed spender, uint256 value);
10   event Mint(address indexed to, uint256 amount);
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   address public owner;
14   string public name;
15   string public symbol;
16   uint256 public totalSupply;
17   uint8 public constant decimals = 6;
18   mapping(address => uint) public balanceOf;
19   mapping(address => mapping (address => uint)) public allowance;
20 
21   uint256 internal constant CAP_TO_GIVE_AWAY = 800000000 * (10 ** uint256(decimals));
22   uint256 internal constant CAP_FOR_THE_TEAM = 200000000 * (10 ** uint256(decimals));
23   uint256 internal constant TEAM_CAP_RELEASE_TIME = 1554000000; // 31 Mar 2019
24 
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   function CoinBundleToken() public {
31     owner = msg.sender;
32     totalSupply = 0;
33     name = "CoinBundle Token";
34     symbol = "BNDL";
35   }
36 
37   function transfer(address _to, uint256 _value) public returns (bool) {
38     require(_to != address(0));
39     require(_value <= balanceOf[msg.sender]);
40     balanceOf[msg.sender] = sub(balanceOf[msg.sender], _value);
41     balanceOf[_to] = add(balanceOf[_to], _value);
42     emit Transfer(msg.sender, _to, _value);
43     return true;
44   }
45 
46   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
47     require(_from != address(0));
48     require(_to != address(0));
49     require(_value <= balanceOf[_from]);
50     require(_value <= allowance[_from][msg.sender]);
51     balanceOf[_from] = sub(balanceOf[_from], _value);
52     balanceOf[_to] = add(balanceOf[_to], _value);
53     allowance[_from][msg.sender] = sub(allowance[_from][msg.sender], _value);
54     emit Transfer(_from, _to, _value);
55     return true;
56   }
57 
58   function approve(address _spender, uint256 _value) public returns (bool) {
59     require(_spender != address(0));
60     allowance[msg.sender][_spender] = _value;
61     emit Approval(msg.sender, _spender, _value);
62     return true;
63   }
64 
65   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
66     require(_spender != address(0));
67     allowance[msg.sender][_spender] = add(allowance[msg.sender][_spender], _addedValue);
68     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
69     return true;
70   }
71 
72   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
73     require(_spender != address(0));
74     uint256 oldValue = allowance[msg.sender][_spender];
75     if (_subtractedValue > oldValue) {
76       allowance[msg.sender][_spender] = 0;
77     } else {
78       allowance[msg.sender][_spender] = sub(oldValue, _subtractedValue);
79     }
80     emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
81     return true;
82   }
83 
84   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
85     require(_to != address(0));
86     require( add(totalSupply, _amount) <= (CAP_TO_GIVE_AWAY + (now >= TEAM_CAP_RELEASE_TIME ? CAP_FOR_THE_TEAM : 0)) );
87     totalSupply = add(totalSupply, _amount);
88     balanceOf[_to] = add(balanceOf[_to], _amount);
89     emit Mint(_to, _amount);
90     emit Transfer(address(0), _to, _amount);
91     return true;
92   }
93 
94   function transferOwnership(address _newOwner) public onlyOwner {
95     require(_newOwner != address(0));
96     owner = _newOwner;
97     emit OwnershipTransferred(owner, _newOwner);
98   }
99 
100   function rename(string _name, string _symbol) public onlyOwner {
101     require(bytes(_name).length > 0 && bytes(_name).length <= 32);
102     require(bytes(_symbol).length > 0 && bytes(_symbol).length <= 32);
103     name = _name;
104     symbol = _symbol;
105   }
106 
107 }