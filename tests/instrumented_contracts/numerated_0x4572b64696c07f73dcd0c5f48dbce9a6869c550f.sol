1 /**
2  * 
3  * CoolCrypto
4  *
5  * @title CoolToken Smart Contract
6  * @author CoolCrypto
7  * @description A Cool Token For Everyone
8  * 
9  **/
10 pragma solidity >=0.4.4;
11 
12 contract CoolToken {
13     string public standard = 'Cool Token';
14     string public name = 'Cool';
15     string public symbol = 'COOL';
16     uint8 public decimals = 8;
17     uint256 public totalSupply = 100000000000000000;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     mapping(address => uint256) public balanceOf;
23     mapping(address => mapping(address => uint256)) public allowed;
24 
25     function Token() {
26         balanceOf[msg.sender] = totalSupply;
27     }
28 
29     function transfer(address _to, uint256 _value) {
30         require(_value > 0 && balanceOf[msg.sender] >= _value);
31 
32         balanceOf[msg.sender] -= _value;
33         balanceOf[_to] += _value;
34 
35         Transfer(msg.sender, _to, _value);
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) {
39         require(_value > 0 && balanceOf[_from] >= _value && allowed[_from][msg.sender] >= _value);
40 
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         allowed[_from][msg.sender] -= _value;
44 
45         Transfer(_from, _to, _value);
46     }
47 
48     function approve(address _spender, uint256 _value) {
49         allowed[msg.sender][_spender] = _value;
50     }
51 
52   
53     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
54         return allowed[_owner][_spender];
55     }
56 
57     function getBalanceOf(address _who) returns(uint256 amount) {
58         return balanceOf[_who];
59     }
60 }