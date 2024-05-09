1 /*
2  * @title CoolToken Smart Contract
3  * @author CoolCrypto
4  * @description A Cool Token For Everyone
5  * 
6  */
7 pragma solidity >=0.4.4;
8 
9 contract CoolToken {
10     string public standard = 'Cool Token';
11     string public name = 'Cool';
12     string public symbol = 'COOL';
13     uint8 public decimals = 18;
14     uint256 public totalSupply = 100000000000000000000000000;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 
19     mapping(address => uint256) public balanceOf;
20     mapping(address => mapping(address => uint256)) public allowed;
21 
22     function Token() {
23         balanceOf[msg.sender] = totalSupply;
24     }
25 
26     function transfer(address _to, uint256 _value) {
27         require(_value > 0 && balanceOf[msg.sender] >= _value);
28 
29         balanceOf[msg.sender] -= _value;
30         balanceOf[_to] += _value;
31 
32         Transfer(msg.sender, _to, _value);
33     }
34 
35     function transferFrom(address _from, address _to, uint256 _value) {
36         require(_value > 0 && balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value);
37 
38         balanceOf[_from] -= _value;
39         balanceOf[_to] += _value;
40         allowed[_from][msg.sender] -= _value;
41 
42         Transfer(_from, _to, _value);
43     }
44 
45     function approve(address _spender, uint256 _value) {
46         allowed[msg.sender][_spender] = _value;
47     }
48 
49   
50     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
51         return allowed[_owner][_spender];
52     }
53 
54     function getBalanceOf(address _who) returns(uint256 amount) {
55         return balanceOf[_who];
56     }
57 }