1 //Copyright CryptoDiamond srl
2 //Luigi Di Benedetto | Brescia (Italy) | CEO CryptoDiamond srl
3 
4 //social:   fb          - https://www.facebook.com/LuigiDiBenedettoBS
5 //          linkedin    - https://www.linkedin.com/in/luigi-di-benedetto
6 
7 //          website     - https://www.cryptodiamond.it/
8 
9 pragma solidity ^0.4.24;
10 
11 contract cryptodiamondwatch {
12     
13     string private ID; //format W-CRIBIXX (es: W-CRIBI01/W-CRIBI02...)
14     string private name;
15     string private surname;
16     string private comment;
17     string private metadataURL;
18     
19     uint256 private nID=1; //from ID (es: W-CRIBI01 => nID: 01)
20     
21     uint256 private amount;
22     
23     uint256 private unlockTime;
24     
25     address private tokenERC721Address;
26     address private owner;
27     address private cryptodiamondAddress;
28     
29     //eventi
30     event Created(string _id, address _address);
31     event InfoSetted(string _name, string _surname, string _comment);
32     event OwnershipChanged(address _address, address _newOwner,string _comment);
33     event Received(address _address ,uint _value);
34     
35     //id dell'orologio e indirizzo del tokenerc721 corrispondente
36     constructor(string _ID, address _tokenERC721Address)public{
37         ID = _ID;
38         tokenERC721Address = _tokenERC721Address;
39         cryptodiamondAddress = msg.sender;
40         name = "not assigned yet";
41         surname = "not assigned yet";
42         comment = "not assigned yet";
43         unlockTime=0;
44         amount=0;
45         owner=msg.sender;
46         emit Created(_ID,msg.sender);
47     }
48     
49     
50     modifier onlyOwner() { 
51     	require (msg.sender == owner); 
52     	_; 
53     }
54     
55     modifier onlyCryptodiamond() { 
56     	require (msg.sender == cryptodiamondAddress); 
57     	_; 
58     }
59     
60     modifier onlyToken() { 
61     	require (msg.sender == tokenERC721Address); 
62     	_; 
63     }
64     
65     
66     function setInfo(string _name, string _surname, string _comment)public onlyCryptodiamond{
67         name = _name;
68         surname = _surname;
69         comment = _comment;
70     }
71     
72     function fee(uint256 _amount,uint256 _fee) private returns(uint256){
73         uint256 calcFee;
74         calcFee=(_fee*_amount)/100;
75         return(_fee*amount/100);
76     }
77     
78     //fallback function
79     function () public payable{
80         uint256 cFee = fee(msg.value,1);
81         owner.transfer(msg.value-cFee);
82         cryptodiamondAddress.transfer(cFee);
83         emit Received(msg.sender,msg.value);
84     }
85     
86     
87     //solo Cryptodiamond può inviare ether inizialmente
88     function ethIN() public payable onlyCryptodiamond{
89             amount+=msg.value;
90             unlockTime=now+7889400;    //7889400; +3 mesi
91             emit Received(msg.sender,msg.value);
92     }
93     
94     function allEthOUT() public onlyOwner{
95         if(now>=unlockTime){
96             owner.transfer(amount);
97             amount = 0;
98             unlockTime = 0;
99         }
100         else
101             revert();
102     }
103 
104    function transferOwnershipTo(address _newOwner, string _comment) external onlyToken{
105         //cryptodiamondAddress.transfer(0.01 ether); //Cryptodiamond fee
106         //amount -=0.01 ether;
107         require(_newOwner != address(0));
108         require(_newOwner != cryptodiamondAddress);
109         emit OwnershipChanged(msg.sender,_newOwner,_comment);
110    		owner = _newOwner;
111    }
112     
113     function getOwner() public constant returns (address){
114         return owner;
115     }
116     function getCryptodiamondAddress() public constant returns (address){
117         return cryptodiamondAddress;
118     }
119     function getID() public constant returns (string){
120         return ID;
121     }
122     
123     function getNID() public constant returns (uint256){
124         return nID;
125     }
126 
127     function getMetadataURL() public constant returns (string){
128         return metadataURL;
129     }
130     
131     function getName() public constant returns (string){
132         return name;
133     }
134     function getSurname() public constant returns (string){
135         return surname;
136     }
137     
138     function getUnlocktime() public constant returns (uint){
139         return unlockTime;
140     }
141     
142     function getAmount() external constant returns (uint){
143         return amount;
144     }
145     
146     
147 }