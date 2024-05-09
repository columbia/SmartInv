1 pragma solidity ^0.6.6;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender==owner);
6         _;
7     }
8     address payable owner;
9     address payable newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         require(_newOwner!=address(0));
12         newOwner = _newOwner;
13     }
14     function acceptOwnership() public {
15         if (msg.sender==newOwner) {
16             owner = newOwner;
17         }
18     }
19 }
20 
21 abstract contract ERC20 {
22     uint256 public totalSupply;
23     function balanceOf(address _owner) view public virtual returns (uint256 balance);
24     function transfer(address _to, uint256 _value) public virtual returns (bool success);
25     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
26     function approve(address _spender, uint256 _value) public virtual returns (bool success);
27     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
28  
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31     
32 }
33 
34 contract Token is Owned,  ERC20 {
35     string public symbol;
36     string public name;
37     uint8 public decimals;
38     
39     mapping (address=>uint256) right;
40     mapping (address=>mapping (string=>uint256)) freeze;
41     mapping (address=>uint256) balances;
42     mapping (address=>mapping (address=>uint256)) allowed;
43     
44     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
45     
46     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
47         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
48         if(freeze[msg.sender]['time']<now){
49             balances[msg.sender]-=_amount;
50             balances[_to]+=_amount;
51             emit Transfer(msg.sender,_to,_amount);
52         }
53         else{
54             require (balances[msg.sender]>=(_amount+freeze[msg.sender]['amount']));
55             balances[msg.sender]-=_amount;
56             balances[_to]+=_amount;
57             emit Transfer(msg.sender,_to,_amount);   
58         }
59         
60         return true;
61     }
62   
63     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
64         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
65         if(freeze[_from]['time']<now){
66             balances[_from]-=_amount;
67             allowed[_from][msg.sender]-=_amount;
68             balances[_to]+=_amount;
69             emit Transfer(_from, _to, _amount);
70         }
71         else{
72             require (balances[_from]>=(_amount+freeze[_from]['amount']));
73             balances[_from]-=_amount;
74             allowed[_from][msg.sender]-=_amount;
75             balances[_to]+=_amount;
76             emit Transfer(_from, _to, _amount);
77         }
78         
79         return true;
80     }
81   
82     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
83         allowed[msg.sender][_spender]=_amount;
84         emit Approval(msg.sender, _spender, _amount);
85         return true;
86     }
87     
88     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90     }
91 }
92 library TransferHelper {
93     function safeTransfer(address token, address to, uint value) internal {
94         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
95         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
96     }
97 
98     function safeTransferFrom(address token, address from, address to, uint value) internal {
99         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
100         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
101     }
102 }
103 contract Frozen is Token{
104     
105     function setRight(address _user, uint256 _status) public onlyOwner returns (bool success){
106         right[_user]=_status;
107         return true;
108     }
109     
110     function freezeTarget(address _target, uint256 _day, uint256 _amount) public returns (bool success){
111         require(right[msg.sender]==1, "You have no authority");
112         freeze[_target]['time'] = now + _day * 1 days;
113         freeze[_target]['amount'] = _amount;
114         return true;
115     }
116     function defrost(address _target) public onlyOwner returns (bool success){
117         freeze[_target]['time'] = now;
118         return true;
119     }
120     function withdrawToken(address token, uint256 value) public onlyOwner{
121         TransferHelper.safeTransfer(token, owner, value);
122     }
123     
124     function getDefrostTime(address _target) public view returns (uint256){
125         if(freeze[_target]['time'] > now){
126             return freeze[_target]['time'] - now;
127         }
128         else{
129             return 0;
130         }
131     }
132       function getFreezeAmount(address _target) public view returns (uint256){
133         return freeze[_target]['amount'];
134     }
135     function getRight(address _target) public view returns (uint256){
136         return right[_target];
137     }
138     constructor() public{
139         symbol = "FROZEN";
140         name = "Frozenswap.org";
141         decimals = 18;
142         totalSupply = 99999*10**18;
143         owner = msg.sender;
144         balances[owner] = totalSupply;
145     }
146     
147     receive () payable external {
148         require(msg.value>0);
149         owner.transfer(msg.value);
150     }
151 }