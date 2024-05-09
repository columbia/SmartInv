1 interface IERC20 {
2     function totalSupply() constant returns (uint256 totalSupply);
3     function balanceOf(address _owner) constant returns (uint256 balance);
4     function transfer(address _to, uint256 _value) returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
6     function approve(address _spender, uint256 _value) returns (bool success);
7     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
8     event Transfer(address indexed _from, address indexed _to, uint256 _value);
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 }
11 
12 contract IGoldToken is IERC20 {
13     uint public constant _totalSupply = 500000000000000;
14     string public constant symbol = "IGP";
15     string public constant name = "IGoldPro";
16     uint8 public constant decimals = 8;
17     
18     
19     mapping(address => uint256) balances;
20     mapping(address=> mapping(address=> uint256)) allowed;
21     function IGoldToken(){
22         balances[msg.sender] = _totalSupply;
23     }
24     function totalSupply() constant returns (uint256 totalSupply){
25         return _totalSupply;
26         
27     }
28     function balanceOf(address _owner) constant returns (uint256 balance){
29         return balances[_owner];
30     }
31     function transfer(address _to, uint256 _value) returns (bool success){
32         require(
33                 balances[msg.sender] >= _value
34                 &&  _value > 0
35             );
36             
37         balances[msg.sender] -= _value;
38         balances[_to] += _value;
39         Transfer(msg.sender, _to, _value);
40         return true;
41         
42     }
43     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
44         require(
45                 allowed[_from][msg.sender] >= _value
46                 && balances[_from] >= _value
47                 && _value > 0
48             );
49             
50         balances[_from] -= _value;
51         balances[_to] += _value;
52         allowed[_from][msg.sender] =- _value;
53         Transfer(_from, _to, _value);
54         return true;
55         
56     }
57     function approve(address _spender, uint256 _value) returns (bool success){
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61         
62     }
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
64         return allowed[_owner][_spender];
65     }
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 }