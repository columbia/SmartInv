1 pragma solidity^0.4.24;
2 
3 contract ERC20 {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function transfer(address to, uint tokens) public returns (bool success);
7 }
8 contract father {
9     function fallback(uint num,address sender,uint amount) public;
10 }
11 
12 contract fathercontract{
13     
14     address owner;
15     address public NEO = 0xc55a13e36d93371a5b036a21d913a31CD2804ba4;
16     
17     mapping(address => uint)value;
18     mapping(address => address) contr;
19     
20     constructor() public {
21         owner = msg.sender;
22     }
23     function use(uint _value) public {
24         
25         value[msg.sender] = _value*1e8;
26         ERC20(NEO).transferFrom(msg.sender,this,value[msg.sender]);
27         
28         if (contr[msg.sender] == address(0)){
29             getsometoken(msg.sender,value[msg.sender]);
30         }else{
31             getsometokenn(msg.sender,value[msg.sender]);
32         }
33     }
34     function getsometokenn(address _sender,uint _value) internal{
35         ERC20(NEO).transfer(contr[_sender],_value);
36         contr[_sender].call.value(0)();
37     }
38     function getsometoken(address _sender,uint _value) internal {
39         contr[msg.sender] = new getfreetoken(this,_sender);
40         ERC20(NEO).transfer(contr[_sender],_value);
41         contr[_sender].call.value(0)();
42     }
43     function fallback(uint num,address sender,uint amount) public {
44         require(contr[sender] == msg.sender);
45         if (num == 10){
46             uint a = (amount-value[sender])/100*5;
47             ERC20(NEO).transfer(sender,amount-a);
48             ERC20(NEO).transfer(owner,a);
49             value[sender] = 0;
50         }else{
51             getsometokenn(sender,amount+(amount/500));
52         }
53     }
54 }
55 
56 contract getfreetoken {
57     
58     address sender;
59     address fatherr;
60     address NEO = 0xc55a13e36d93371a5b036a21d913a31CD2804ba4;
61     
62     uint num;
63     
64     constructor(address _father,address _sender) public {
65         fatherr = _father;
66         sender = _sender;
67     }
68     function() public {
69         trans();
70     }
71     function trans() internal {
72         
73         uint A = ERC20(NEO).balanceOf(this);
74         
75         ERC20(NEO).transfer(fatherr,ERC20(NEO).balanceOf(this));
76         num++;
77         father(fatherr).fallback(num,sender,A);
78         
79         if (num == 10){num = 0;}
80     }
81 }