1 pragma solidity ^0.4.10;
2 contract Token {
3     uint256 public totalSupply;
4     function balanceOf(address _owner) constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
7     function approve(address _spender, uint256 _value) returns (bool success);
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 
14 /*  ERC 20 token */
15 contract StandardToken is Token {
16 
17     function transfer(address _to, uint256 _value) returns (bool success) {
18       if (balances[msg.sender] >= _value && _value > 0) {
19         balances[msg.sender] -= _value;
20         balances[_to] += _value;
21         Transfer(msg.sender, _to, _value);
22         return true;
23       } else {
24         return false;
25       }
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
29       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30         balances[_to] += _value;
31         balances[_from] -= _value;
32         allowed[_from][msg.sender] -= _value;
33         Transfer(_from, _to, _value);
34         return true;
35       } else {
36         return false;
37       }
38     }
39 
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56 }
57 // requires 50,000,000 INDI deposited here for bounty
58 contract INDISafe {
59   mapping (address => uint256) allocations;
60   uint256 public unlockDate;
61   address public INDI;
62   uint256 public constant exponent = 10**18;
63 
64   function INDISafe() {
65     INDI = 0xe8c09672cfb9cfce6e2edbb01057d9fa569f97c1;
66     unlockDate = 1515283200;
67     allocations[0x91c594706246Bed9a99CB49718b95D0F067042C8] = 50000000; 
68     
69   }
70 
71   function unlock() external {
72     if(now < unlockDate) revert();
73     uint256 entitled = allocations[msg.sender];
74     allocations[msg.sender] = 0;
75     if(!StandardToken(INDI).transfer(msg.sender, entitled * exponent)) revert();
76   }
77 
78 }