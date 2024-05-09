1 pragma solidity ^0.4.11;
2 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
3 
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 /// @author braziliex dev team - <dev@braziliex.com>
6 contract Token {
7     uint256 public totalSupply;
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 
20 contract StandardToken is Token {
21 
22     mapping (address => uint256) balances;
23     mapping (address => mapping (address => uint256)) allowed;
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         }
32         else {
33             return false;
34         }
35     }
36 
37 
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
39         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
40             balances[_to] += _value;
41             balances[_from] -= _value;
42             allowed[_from][msg.sender] -= _value;
43             Transfer(_from, _to, _value);
44             return true;
45         }
46         else {
47             return false;
48         }
49     }
50 
51 
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success) {
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
63       return allowed[_owner][_spender];
64     }
65 
66 }
67 
68 
69 contract BraziliexToken is StandardToken {
70 
71     string constant public name = "BraziliexToken";
72     string constant public symbol = "BRZX";
73     uint8 constant public decimals = 8;
74 
75 
76     function () {
77         //if ether is sent to this address, send it back.
78         throw;
79     }
80 
81 
82     function BraziliexToken() {
83         balances[msg.sender] = 2100000000000000;
84         totalSupply = 2100000000000000; // 21M
85     }
86 }