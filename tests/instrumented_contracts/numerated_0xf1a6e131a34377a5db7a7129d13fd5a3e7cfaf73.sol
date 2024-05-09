1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface {
4     event Transfer( address indexed _from, address indexed _to, uint _value);
5     event Approval( address indexed _owner, address indexed _spender, uint _value);
6    
7     function totalSupply() constant public returns (uint _supply);
8     function balanceOf( address _who ) constant public returns (uint _value);
9     function transfer( address _to, uint _value ) public returns (bool _success);
10     function approve( address _spender, uint _value ) public returns (bool _success);
11     function allowance( address _owner, address _spender ) constant public returns (uint _allowance);
12     function transferFrom( address _from, address _to, uint _value ) public returns (bool _success);
13     
14 } 
15 
16 contract SimpleToken is ERC20Interface{
17     address public owner;
18     string public name;
19     uint public decimals;
20     string public symbol;
21     uint public totalSupply;
22     uint private E18 = 1000000000000000000;
23     mapping (address => uint) public balanceOf;
24     mapping (address => mapping ( address => uint)) public approvals;
25     
26     function Simpletoken() public{
27         name = "GangnamToken";
28         decimals = 18;
29         symbol = "GNX";
30         totalSupply = 10000000000 * E18;
31         owner = msg.sender;
32         balanceOf[msg.sender] = totalSupply;
33     }
34     
35     function totalSupply() constant public returns (uint){
36         return totalSupply;
37     }
38     
39     function balanceOf(address _who) constant public returns (uint){
40         return balanceOf[_who];
41     }
42 
43     function transfer(address _to, uint _value) public returns (bool){
44             require(balanceOf[msg.sender] >= _value);
45             balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
46             balanceOf[_to] = balanceOf[_to] + _value;
47             
48             Transfer(msg.sender, _to, _value);
49             return true;
50         }
51     function approve(address _spender, uint _value) public returns (bool){
52             require(balanceOf[msg.sender] >= _value);
53             approvals[msg.sender][_spender] = _value;
54             Approval(msg.sender, _spender, _value);
55             return true;
56         }
57     function allowance(address _owner, address _spender) constant public returns (uint){
58             return approvals[_owner][_spender];
59         }
60     function transferFrom(address _from, address _to, uint _value) public returns (bool)
61         {
62             require(balanceOf[_from] >= _value);
63             require(approvals[_from][msg.sender] >= _value);
64             approvals[_from][msg.sender] = approvals[_from][msg.sender] - _value;
65             balanceOf[_from] = balanceOf[_from] - _value;
66             balanceOf[_to] = balanceOf[_to] + _value;
67             
68             Transfer(_from, _to, _value);
69             
70             return true;
71         }
72     }