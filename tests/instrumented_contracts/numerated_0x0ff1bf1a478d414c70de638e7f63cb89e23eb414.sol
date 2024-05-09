1 pragma solidity ^0.4.18;
2 
3 contract LetoCoin{
4 
5     string public constant name = 'LetoCoin';
6     string public constant symbol = 'LETO';
7     uint8 public constant decimals = 10;
8     uint256 public constant totalSupply = 8000000 * 10**uint256(decimals);
9     
10     mapping (address => uint256) private balances;
11     mapping (address => mapping (address => uint256)) private allowed;
12     
13     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     function LetoCoin() public {
17         balances[msg.sender] = totalSupply;
18         Transfer(0x0, msg.sender, totalSupply);
19     }
20     
21     function balanceOf(address _owner) constant public returns (uint256 balance){
22         return balances[_owner];
23     }
24     
25     function transfer(address _to, uint256 _value) public returns (bool success) {
26         if (_value != 0){
27             require(balances[msg.sender] >= _value);
28             require(balances[_to] + _value > balances[_to]);
29             balances[msg.sender] -= _value;
30             balances[_to] += _value;
31         }
32         Transfer(msg.sender, _to, _value); 
33         return true;
34     }
35     
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
37         if (_value != 0){
38             require(allowed[_from][msg.sender] >= _value);
39             require(balances[_from] >= _value);
40             require(balances[_to] + _value > balances[_to]);
41             balances[_from] -= _value;
42             allowed[_from][msg.sender] -= _value;
43             balances[_to] += _value;
44         }
45         Transfer(_from, _to, _value); 
46         return true;
47     }
48     
49     function approve(address _spender, uint256 _value) public returns (bool success){
50         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
51         allowed[msg.sender][_spender] = _value;
52         Approval(msg.sender, _spender, _value);
53         return true;
54     }
55     
56     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
57         return allowed[_owner][_spender];
58     }
59     
60     function () public payable {
61         revert();
62     }
63     
64 }