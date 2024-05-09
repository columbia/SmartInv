1 pragma solidity ^0.4.24;
2 contract ERC {
3 function totalSupply() public constant returns (uint256);
4 function balanceOf(address _who) public constant returns (uint256);
5 function allowance(address _owner, address _spender) public constant returns (uint256);
6 function transfer(address _to, uint256 _value) public returns (bool);
7 function approve(address _spender, uint256 _toValue) public returns (bool);
8 function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
9 event Transfer(address indexed from, address indexed to, uint256 value);
10 event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 contract Ownable {
13 address public owner;
14 event OwnershipRenounced(address indexed previousOwner);
15 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 constructor() public {
17 owner = msg.sender;
18 }
19 modifier onlyOwner() {
20 require(msg.sender == owner);
21 _;
22 }
23 function renounceOwnership() public onlyOwner {
24 emit OwnershipRenounced(owner);
25 owner = address(0);
26 }
27 function transferOwnership(address _newOwner) public onlyOwner {
28 require(_newOwner != address(0));
29 emit OwnershipTransferred(owner, _newOwner);
30 owner = _newOwner;
31 }
32 }
33 contract Pausable is Ownable {
34 event Paused();
35 event Unpaused();
36 bool public paused = false;
37 modifier whenNotPaused() {
38 require(!paused);
39 _;
40 }
41 modifier whenPaused() {
42 require(paused);
43 _;
44 }
45 function pause() public onlyOwner whenNotPaused {
46 paused = true;
47 emit Paused();
48 }
49 function unpause() public onlyOwner whenPaused {
50 paused = false;
51 emit Unpaused();
52 }
53 }
54 library SafeMath {
55 function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
56 require(_b <= _a);
57 uint256 c = _a - _b;
58 return c;
59 }
60 function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
61 uint256 c = _a + _b;
62 require(c >= _a);
63 return c;
64 }
65 }
66 contract TeaiToken is ERC, Pausable {
67 using SafeMath for uint256;
68 mapping (address => uint256) balances;
69 mapping (address => mapping (address => uint256)) allowed;
70 string public symbol;
71 string public name;
72 uint256 public decimals;
73 uint256 _totalSupply;
74 constructor() public {
75 symbol = "TEAI";
76 name = "TeaiToken";
77 decimals = 18;
78 _totalSupply = 1*(10**29);
79 balances[owner] = _totalSupply;
80 emit Transfer(address(0), owner, _totalSupply);
81 }
82 function totalSupply() public constant returns (uint256) {
83 return _totalSupply;
84 }
85 function balanceOf(address _owner) public constant returns (uint256) {
86 return balances[_owner];
87 }
88 function allowance(address _owner, address _spender) public constant returns (uint256) {
89 return allowed[_owner][_spender];
90 }
91 function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
92 require(_value <= balances[msg.sender]);
93 require(_value>0);
94 require(_to != address(0));
95 balances[msg.sender] = balances[msg.sender].sub(_value);
96 balances[_to] = balances[_to].add(_value);
97 emit Transfer(msg.sender, _to, _value);
98 return true;
99 }
100 function approve(address _spender, uint256 _toValue) public whenNotPaused returns (bool) {
101 allowed[msg.sender][_spender] = _toValue;
102 emit Approval(msg.sender, _spender, _toValue);
103 return true;
104 }
105 function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
106 require(_value <= balances[_from]);
107 require(_value <= allowed[_from][msg.sender]);
108 require(_value>0);
109 require(_to != address(0));
110 balances[_from] = balances[_from].sub(_value);
111 balances[_to] = balances[_to].add(_value);
112 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113 emit Transfer(_from, _to, _value);
114 return true;
115 }
116 }