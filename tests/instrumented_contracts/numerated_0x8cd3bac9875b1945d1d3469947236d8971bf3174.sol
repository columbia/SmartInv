1 pragma solidity >=0.4.4;
2 
3 contract CoolToken {
4     string public standard = 'CoolToken';
5     string public name = 'Cool';
6     string public symbol = 'COOL';
7     uint8 public decimals = 18;
8     uint256 public totalSupply = 100000000000000000000000000;
9 
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 
13     mapping(address => uint256) public balanceOf;
14     mapping(address => mapping(address => uint256)) public allowed;
15 
16     function Token() {
17         balanceOf[msg.sender] = totalSupply;
18     }
19 
20     function transfer(address _to, uint256 _value) {
21         require(_value > 0 && balanceOf[msg.sender] >= _value);
22 
23         balanceOf[msg.sender] -= _value;
24         balanceOf[_to] += _value;
25 
26         Transfer(msg.sender, _to, _value);
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) {
30         require(_value > 0 && balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value);
31 
32         balanceOf[_from] -= _value;
33         balanceOf[_to] += _value;
34         allowed[_from][msg.sender] -= _value;
35 
36         Transfer(_from, _to, _value);
37     }
38 
39     function approve(address _spender, uint256 _value) {
40         allowed[msg.sender][_spender] = _value;
41     }
42 
43   
44     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
45         return allowed[_owner][_spender];
46     }
47 
48     function getBalanceOf(address _who) returns(uint256 amount) {
49         return balanceOf[_who];
50     }
51 }