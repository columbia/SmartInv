1 pragma solidity ^0.4.11;
2 
3 
4 interface ERC20 {
5     function totalSupply() constant returns (uint _totalSupply);
6     function balanceOf(address _owner) constant returns (uint balance);
7     function transfer(address _to, uint _value) returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) returns (bool success);
9     function approve(address _spender, uint _value) returns (bool success);
10     function allowance(address _owner, address _spender) constant returns (uint remaining);
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 contract Unity3d is ERC20 {
15     string public constant symbol = "U3D";
16     string public constant name = "unity3d";
17     uint8 public constant decimals = 1;
18     
19     uint private constant __totalSupply = 12800000;
20     mapping (address => uint) private __balanceOf;
21     mapping (address => mapping (address => uint)) private __allowances;
22     
23     function MyFirstToken() {
24             __balanceOf[msg.sender] = __totalSupply;
25     }
26     
27     function totalSupply() constant returns (uint _totalSupply) {
28         _totalSupply = __totalSupply;
29     }
30     
31     function balanceOf(address _addr) constant returns (uint balance) {
32         return __balanceOf[_addr];
33     }
34     
35     function transfer(address _to, uint _value) returns (bool success) {
36         if (_value > 0 && _value <= balanceOf(msg.sender)) {
37             __balanceOf[msg.sender] -= _value;
38             __balanceOf[_to] += _value;
39             return true;
40         }
41         return false;
42     }
43     
44     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
45         if (__allowances[_from][msg.sender] > 0 &&
46             _value > 0 &&
47             __allowances[_from][msg.sender] >= _value && 
48             __balanceOf[_from] >= _value) {
49             __balanceOf[_from] -= _value;
50             __balanceOf[_to] += _value;
51             // Missed from the video
52             __allowances[_from][msg.sender] -= _value;
53             return true;
54         }
55         return false;
56     }
57     
58     function approve(address _spender, uint _value) returns (bool success) {
59         __allowances[msg.sender][_spender] = _value;
60         return true;
61     }
62     
63     function allowance(address _owner, address _spender) constant returns (uint remaining) {
64         return __allowances[_owner][_spender];
65     }
66 }