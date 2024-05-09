1 pragma solidity ^0.4.12;
2 contract ERC {
3      function totalSupply() constant public returns (uint _totalSupply);
4      function balanceOf(address _owner) constant  public returns (uint _balance);
5      function transfer(address _to, uint _value)  public returns (bool success);
6      function transferFrom(address _from, address _to, uint _value)  public returns (bool _success);
7      function approve(address _spender, uint _value)  public returns (bool success);
8      function allowance(address _owner, address _spender)  public constant returns (uint _remaining);
9      event Transfer(address indexed _from, address indexed _to, uint _value);
10      event Approval(address indexed _owner, address indexed _spender, uint _value);
11  }
12 contract ERC20 is ERC {
13 	uint public totalSupply;
14 	string public name;
15 	string public symbol;
16 	uint8 public decimals;
17 	address public owner;
18 	uint   token;
19 	
20 	mapping(address=>uint) balance;
21 	mapping (address => mapping (address => uint)) allowed;
22 	event Transfer(address indexed _from, address indexed _to, uint _value);
23 	event Approval(address indexed _owner, address indexed _spender, uint _value);
24 	
25 	function ERC20()  public {
26 	    owner=msg.sender;
27         totalSupply=1000000000;
28         name="Aasim";
29         symbol="AA";
30         decimals=18;
31 		
32 	}
33 	modifier checkAdmin(){
34 		if (msg.sender!=owner)revert();
35 		_;
36 		}
37 			
38     
39 	function totalSupply() constant public returns (uint _totalSupply){
40 		return totalSupply;
41 
42 	}
43 	function balanceOf(address _owner) constant public  returns (uint _balance ){
44 		return balance[_owner];
45 
46 	}
47 	function transfer(address _to, uint _value)  public returns (bool _success){
48 		if(_to==address(0))revert();
49 		if(balance[msg.sender]<_value||_value==0)revert();
50 		token =_value;
51 		balance[msg.sender]-=token;
52 		balance[_to]+=token;
53 		if(balance[_to]+_value<balance[_to]) revert();
54 		Transfer(msg.sender,_to,token);
55 		return true;
56 
57 	}
58 	function allowance(address _owner, address _spender) public constant returns (uint _remaining){
59 		return allowed[_owner][_spender];
60 	}
61 	function approve(address _spender, uint _value) public returns (bool _success){
62 		allowed[msg.sender][_spender]=_value;
63 		Approval(msg.sender,_spender,_value);
64 		return true;
65 	}
66 	function transferFrom(address _from, address _to, uint _value) public returns (bool _success){
67 		if(_to==address(0))revert();
68 		if(balance[_from] < _value)revert();
69 		if(allowed[_from][msg.sender] ==0)revert();
70 		if(allowed[_from][msg.sender] >=_value){
71 		  allowed[_from][msg.sender]-=_value;
72 		  if(balance[_to]+_value<balance[_to]) revert();
73 			balance[_from]-=_value;
74 			balance[_to]+=_value;
75 		
76 			Transfer(msg.sender,_to,_value);
77 			return true;
78 
79 		}
80 		else{
81 			revert();
82 		}
83 	}
84 	
85 	function()  payable
86     {
87         uint amount1=2500*msg.value;
88         amount1=amount1/1 ether;
89         balance[msg.sender]+=amount1;
90         
91         totalSupply-=amount1;
92     }
93     function kill()checkAdmin   returns(bool _success){
94     	selfdestruct(owner);
95     	return true;
96     }
97 }