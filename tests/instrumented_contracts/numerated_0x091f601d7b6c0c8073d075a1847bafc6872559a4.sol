1 pragma solidity ^0.4.8;
2 contract Clue {
3 
4   string public constant symbol = "CLUE";
5   string public constant name = "Clue";
6   uint8 public constant decimals = 8;
7   
8   event Transfer(address indexed from, address indexed to, uint value);
9   event Approval( address indexed owner, address indexed spender, uint value);
10 
11   mapping( address => uint ) _balances;
12   mapping( address => mapping( address => uint ) ) _approvals;
13   
14   uint public _supply = 100000000;
15   
16   function Clue() {
17     _balances[msg.sender] = 10000000000000000;
18   }
19   
20   function totalSupply() constant returns (uint supply) {
21     return _supply;
22   }
23   
24   function balanceOf( address who ) constant returns (uint value) {
25     return _balances[who];
26   }
27   
28   function transfer( address to, uint value) returns (bool ok) {
29     if( _balances[msg.sender] < value ) {
30       throw;
31     }
32     if( !safeToAdd(_balances[to], value) ) {
33       throw;
34     }
35     _balances[msg.sender] -= value;
36     _balances[to] += value;
37     Transfer( msg.sender, to, value );
38     return true;
39   }
40   
41   function transferFrom( address from, address to, uint value) returns (bool ok) {
42     if( _balances[from] < value ) {
43       throw;
44     }
45     if( _approvals[from][msg.sender] < value ) {
46       throw;
47     }
48     if( !safeToAdd(_balances[to], value) ) {
49       throw;
50     }
51     _approvals[from][msg.sender] -= value;
52     _balances[from] -= value;
53     _balances[to] += value;
54     Transfer( from, to, value );
55     return true;
56   }
57   
58   function approve(address spender, uint value) returns (bool ok) {
59     _approvals[msg.sender][spender] = value;
60     Approval( msg.sender, spender, value );
61     return true;
62   }
63   
64   function allowance(address owner, address spender) constant returns (uint _allowance) {
65     return _approvals[owner][spender];
66   }
67   
68   function safeToAdd(uint a, uint b) internal returns (bool) {
69     return (a + b >= a);
70   }
71 }