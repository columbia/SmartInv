1 pragma solidity ^0.4.24;
2 
3 contract Spektral {
4     string public name;
5     string public symbol;
6     uint256 public totalSupply;
7     uint8 public decimals;
8 
9     mapping (address => uint256) balances;
10     mapping (address => mapping (address => uint256)) allowed;
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 
15     constructor() public {
16         name = "Spektral";
17         symbol = "SPK";
18         decimals = 18;
19         totalSupply = 600000000000 * 10**18;
20         balances[msg.sender] = totalSupply;
21     }
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {
24         if (balances[msg.sender] >= _value && _value > 0) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             emit Transfer(msg.sender, _to, _value);
28             return true;
29         }else{
30             return false;
31         }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             emit Transfer(_from, _to, _value);
40             return true;
41         }else{
42             return false;
43         }
44     }
45 
46     function balanceOf(address _owner) public view returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53 
54     function approve(address _spender, uint256 _value) public returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 }