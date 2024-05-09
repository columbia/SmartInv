1 pragma solidity ^0.4.25;
2 
3 contract ERC20 {
4     function approve(address spender, uint256 value) external returns (bool);
5     function transferFrom(address from, address to, uint value) public returns (bool ok);
6 }
7 
8 contract XEXHolder{
9     address private holder1_;
10     address private holder2_;
11     address private holder3_;
12     bool private holder1Reset_;
13     bool private holder2Reset_;
14     bool private holder3Reset_;
15     bool private holder1Transaction_;
16     bool private holder2Transaction_;
17     bool private holder3Transaction_;
18 
19     address private token_;
20     uint256 private transactionNonce_;
21     address private transactionTo_;
22     uint256 private transactionValue_;
23 
24     event HolderSetted(address indexed _address1,address indexed _address2,address indexed _address3);
25     event HolderReseted(bool _vote);
26     event TransactionStarted(address indexed _address,uint _value);
27     event TransactionConfirmed(address indexed _address,bool _vote);
28     event TransactionSubmitted(address indexed _address,uint _value);
29     
30     modifier onlyHolder() {
31         require(isHolder(msg.sender));
32         _;
33     }
34     
35     constructor(address _token) public{
36         token_=_token;
37         holder1_=msg.sender;
38         holder2_=address(0);
39         holder3_=address(0);
40         holder1Reset_=false;
41         holder2Reset_=false;
42         holder3Reset_=false;
43         holder1Transaction_=false;
44         holder2Transaction_=false;
45         holder3Transaction_=false;
46     }
47     
48     function isHolder(address _address) public view returns (bool) {
49         if(_address==address(0)){
50             return false;
51         }
52         return _address==holder1_ || _address==holder2_ || _address==holder3_;
53     }
54     
55     function setHolder(address _address1,address _address2,address _address3) public onlyHolder{
56         require(_address1!=address(0) && _address2!=address(0) && _address3!=address(0));
57         require(_address1!=_address2 && _address1!=_address3 && _address2!=_address3);
58         
59         uint _vote=0;
60         if(holder1_==address(0)||holder1Reset_){
61             _vote++;
62         }
63         if(holder2_==address(0)||holder2Reset_){
64             _vote++;
65         }
66         if(holder3_==address(0)||holder3Reset_){
67             _vote++;
68         }
69         require(_vote>=2);
70         
71         holder1_=_address1;
72         holder2_=_address2;
73         holder3_=_address3;
74         holder1Reset_=false;
75         holder2Reset_=false;
76         holder3Reset_=false;
77         clearTransaction();
78         
79         emit HolderSetted(holder1_,holder2_,holder3_);
80     }
81     
82     function resetHolder(bool _vote) public onlyHolder{
83         if(msg.sender==holder1_){
84             holder1Reset_=_vote;
85         }
86         if(msg.sender==holder2_){
87             holder2Reset_=_vote;
88         }
89         if(msg.sender==holder3_){
90             holder3Reset_=_vote;
91         }
92         emit HolderReseted(_vote);
93     }
94     
95     function startTransaction(address _address, uint256 _value) public onlyHolder{
96         require(_address != address(0) && _value > 0);
97 
98         transactionNonce_ = uint256(keccak256(abi.encodePacked(block.difficulty,now)));
99         transactionTo_ = _address;
100         transactionValue_ = _value;
101         emit TransactionStarted(_address,_value);
102 
103         confirmTransaction(transactionNonce_, true);
104     }
105     
106     function showTransaction() public onlyHolder view returns(address _address, uint256 _value,uint256 _nonce){
107         return (transactionTo_,transactionValue_,transactionNonce_);
108     }
109 
110     function confirmTransaction(uint256 _nonce, bool _vote) public onlyHolder{
111         require(transactionNonce_==_nonce);
112         
113         if(msg.sender==holder1_){
114             holder1Transaction_=_vote;
115         }
116         if(msg.sender==holder2_){
117             holder2Transaction_=_vote;
118         }
119         if(msg.sender==holder3_){
120             holder3Transaction_=_vote;
121         }
122         emit TransactionConfirmed(msg.sender,_vote);
123     }
124 
125     function submitTransaction() public onlyHolder{
126         require(transactionTo_ != address(0) && transactionValue_ > 0);
127         require(holder1Transaction_ && holder2Transaction_ && holder3Transaction_);
128         require(!holder1Reset_ && !holder2Reset_ && !holder3Reset_);
129         
130         ERC20 _token = ERC20(token_);
131         _token.approve(this, transactionValue_);
132         _token.transferFrom(this,transactionTo_,transactionValue_);
133         
134         emit TransactionSubmitted(transactionTo_,transactionValue_);
135         
136         clearTransaction();
137     }
138     
139     function clearTransaction() internal{
140         transactionNonce_=0;
141         transactionTo_=address(0);
142         transactionValue_=0;
143     }
144 }