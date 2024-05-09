1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5       uint256 c = a * b;
6       assert(a == 0 || c / a == b);
7       return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11       uint256 c = a / b;
12       return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16       assert(b <= a);
17       return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21       uint256 c = a + b;
22       assert(c >= a);
23       return c;
24     }
25 }
26 
27 contract Owned {
28   address public owner;
29   function Owned() {
30     owner = msg.sender;
31   }
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36   function transferOwnership(address newOwner) onlyOwner {
37     require(newOwner != address(0));      
38     owner = newOwner;
39   }
40 }
41 
42 
43 
44 contract ERC20 {
45     uint256 public totalSupply;
46     function balanceOf(address who) constant returns (uint256);
47     function transfer(address to, uint256 value) returns (bool);
48     function transferFrom(address from, address to, uint256 value) returns (bool);
49     function approve(address spender, uint256 value) returns (bool);
50     function allowance(address owner, address spender) constant returns (uint256);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 
56 contract StandardToken is ERC20 {
57     
58     using SafeMath for uint256;
59     
60     mapping(address => uint256) balances;
61     
62     mapping (address => mapping (address => uint256)) allowed;
63     
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function transfer(address _to, uint256 _value) returns (bool) {
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
76       var _allowance = allowed[_from][msg.sender];
77       balances[_to] = balances[_to].add(_value);
78       balances[_from] = balances[_from].sub(_value);
79       allowed[_from][msg.sender] = _allowance.sub(_value);
80       Transfer(_from, _to, _value);
81       return true;
82     }
83 
84    function approve(address _spender, uint256 _value) returns (bool) {
85     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
86     allowed[msg.sender][_spender] = _value;
87     Approval(msg.sender, _spender, _value);
88     return true;
89    }
90 
91   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
92     return allowed[_owner][_spender];
93   }
94 }
95   
96 contract EthereumAlpes is StandardToken, Owned {
97   string public constant name = "Ethereum Alpes";
98   string public constant symbol = "EALP";
99   uint public constant decimals = 18;
100   uint256 public initialSupply;
101 
102   function EthereumAlpes () {
103    totalSupply = 3000000 * 10 ** decimals;
104    balances[msg.sender] = totalSupply;
105    initialSupply = totalSupply; 
106    Transfer(0, this, totalSupply);
107    Transfer(this, msg.sender, totalSupply);
108   }
109 }