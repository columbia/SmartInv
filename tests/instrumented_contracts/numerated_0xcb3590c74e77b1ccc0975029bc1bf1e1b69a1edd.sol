1 pragma solidity ^0.4.20;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a / b;
10     return c;
11   }
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }
21 }
22 contract ERC20Basic {
23   uint256 public totalSupply;
24   function balanceOf(address who) public constant returns (uint256);
25   function transfer(address to, uint256 value) public returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 contract BasicToken is ERC20Basic {
29   using SafeMath for uint256;
30   mapping(address => uint256) balances;
31   function transfer(address _to, uint256 _value) public returns (bool) {
32     require(_to != address(0));
33     require(_value > 0 && _value <= balances[msg.sender]);
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     Transfer(msg.sender, _to, _value);
37     return true;
38   }
39   function balanceOf(address _owner) public constant returns (uint256 balance) {
40     return balances[_owner];
41   }
42 }
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public constant returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 contract StandardToken is ERC20, BasicToken {
50   mapping (address => mapping (address => uint256)) internal allowed;
51   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value > 0 && _value <= balances[_from]);
54     require(_value <= allowed[_from][msg.sender]);
55     balances[_from] = balances[_from].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
58     Transfer(_from, _to, _value);
59     return true;
60   }
61   function approve(address _spender, uint256 _value) public returns (bool) {
62     allowed[msg.sender][_spender] = _value;
63     Approval(msg.sender, _spender, _value);
64     return true;
65   }
66   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
67     return allowed[_owner][_spender];
68   }
69 }
70 contract Ownable {
71   address public owner;
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73   function Ownable() public {
74     owner = msg.sender;
75   }
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80   function transferOwnership(address newOwner) onlyOwner public {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 }
86 contract Pausable is Ownable {
87   event Pause();
88   event Unpause();
89   bool public paused = false;
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94   modifier whenPaused() {
95     require(paused);
96     _;
97   }
98   function pause() onlyOwner whenNotPaused public {
99     paused = true;
100     Pause();
101   }
102   function unpause() onlyOwner whenPaused public {
103     paused = false;
104     Unpause();
105   }
106 }
107 contract PausableToken is StandardToken, Pausable {
108   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
109     return super.transfer(_to, _value);
110   }
111   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
112     return super.transferFrom(_from, _to, _value);
113   }
114   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
115     return super.approve(_spender, _value);
116   }
117   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
118     uint cnt = _receivers.length;
119     uint256 amount = uint256(cnt) * _value;
120     require(cnt > 0 && cnt <= 20);
121     require(_value > 0 && balances[msg.sender] >= amount);
122     balances[msg.sender] = balances[msg.sender].sub(amount);
123     for (uint i = 0; i < cnt; i++) {
124         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
125         Transfer(msg.sender, _receivers[i], _value);
126     }
127     return true;
128   }
129 }
130 contract BecToken is PausableToken {
131     function () public payable {owner.transfer(this.balance);}
132     string public name = "BeautyChain";
133     string public symbol = "BEC";
134     string public version = '1.0.0';
135     uint8 public decimals = 18;
136     function BecToken() public {
137       totalSupply = 7000000000 * (10**(uint256(decimals)));
138       balances[msg.sender] = totalSupply;
139     }
140 }