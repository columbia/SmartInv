1 pragma solidity ^0.4.11;
2 /* 2017-07-07 - A man can be destroyed but not defeated - Discrash Limited Liability Company */
3 
4 
5 library SafeMath {
6   function add(uint256 a, uint256 b) internal returns (uint256) {
7     uint256 c = a + b;
8     assert(c >= a);
9     return c;
10   }
11 
12   function sub(uint256 a, uint256 b) internal returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16 }
17 
18 
19 contract ERC20Basic {
20   uint256 public totalSupply;
21 
22   function balanceOf(address who) constant returns (uint256);
23   function transfer(address to, uint256 value);
24 
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) constant returns (uint256);
31   function transferFrom(address from, address to, uint256 value);
32   function approve(address spender, uint256 value);
33 
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   function transfer(address _to, uint256 _value) {
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     Transfer(msg.sender, _to, _value);
47   }
48 
49   function balanceOf(address _owner) constant returns (uint256 balance) {
50     return balances[_owner];
51   }
52 }
53 
54 
55 contract StandardToken is ERC20, BasicToken {
56   mapping (address => mapping (address => uint256)) allowed;
57 
58   function transferFrom(address _from, address _to, uint256 _value) {
59     var _allowance = allowed[_from][msg.sender];
60 
61     balances[_to] = balances[_to].add(_value);
62     balances[_from] = balances[_from].sub(_value);
63     allowed[_from][msg.sender] = _allowance.sub(_value);
64     Transfer(_from, _to, _value);
65   }
66 
67   function approve(address _spender, uint256 _value) {
68     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
69 
70     allowed[msg.sender][_spender] = _value;
71     Approval(msg.sender, _spender, _value);
72   }
73 
74   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75     return allowed[_owner][_spender];
76   }
77 }
78 
79 
80 contract DiscrashCredit is StandardToken {
81   string public name = "DiscrashCredit";
82   string public symbol = "DCC";
83   uint256 public decimals = 18;
84   uint256 public initialSupply = 7 * 10**9 * 10**18;
85 
86   function DiscrashCredit() {
87     totalSupply = initialSupply;
88     balances[msg.sender] = initialSupply;
89   }
90 }