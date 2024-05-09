1 pragma solidity ^0.4.19;
2 
3 contract HCToken {
4     address public owner;
5     string public constant name = "Hash Credit Token";
6     string public constant symbol = "HCT";
7     uint256 public constant decimals = 6;
8     uint256 public constant totalSupply = 15 * 100 * 1000 * 1000 * 10 ** decimals;
9     
10     mapping(address => uint256) balances;
11     mapping(address => mapping(address => uint256)) allowed;
12 
13     modifier onlyPayloadSize(uint size) {
14         if (msg.data.length != size + 4) {
15             throw;
16         }
17         _;
18     }
19 
20     function HCToken() {
21         owner = msg.sender;
22         balances[owner] = totalSupply;
23     }
24 
25     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
26         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
27         balances[msg.sender] -= _value;
28         balances[_to] += _value;
29         Transfer(msg.sender, _to, _value);
30         return true;
31     }
32 
33     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
34         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
35         balances[_to] += _value;
36         balances[_from] -= _value;
37         allowed[_from][msg.sender] -= _value;
38         Transfer(_from, _to, _value);
39         return true;
40     }
41     
42   
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint _value) returns (bool success) {
48         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
49 
50         allowed[msg.sender][_spender] = _value;
51         Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function allowance(address _owner, address _spender) constant returns (uint remaining) {
56         return allowed[_owner][_spender];
57     }
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 
62 }