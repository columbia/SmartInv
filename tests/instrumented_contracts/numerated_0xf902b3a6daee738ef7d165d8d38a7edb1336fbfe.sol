1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
35 contract ERC20 {
36    function  transfer(address _to, uint256 _value) returns (bool success);
37   function balanceOf(address _owner) constant returns (uint256 balance);
38 }
39 
40 
41 contract PlaakPreSale {
42 
43     using SafeMath for uint256;
44 
45     address             public admin;
46     uint                public raisedWei;
47     bool                public haltSale = false; 
48     bool                private enableTransfer = true; 
49 
50     // Plaak Coin
51     ERC20               public token;
52     
53     address ico ; 
54     
55     function PlaakPreSale(address _ico, address _token){
56         token = ERC20(_token);
57         ico   = _ico; 
58         admin = msg.sender;
59     }
60 
61     function setHaltSale( bool halt ) {
62         require( msg.sender == admin );
63         haltSale = halt;
64     }
65 
66     function seEnableTransfer( bool _transfer ) {
67         require( msg.sender == admin );
68         enableTransfer = _transfer; 
69     }    
70 
71     function seIcoAddress( address _ico ) {
72         require( msg.sender == admin );
73         ico = _ico;
74     }    
75 
76     function drain(uint _amount) {
77         require( msg.sender == admin );
78         if ( _amount == 0 ){
79             admin.transfer(this.balance);
80         }else{
81             token.transfer(admin,_amount);
82         }
83     }
84     
85     function sendTo(address _to, uint _amount){
86         require( msg.sender == admin );
87 
88         token.transfer(_to, _amount);
89   
90     }
91     
92     function() payable {
93         buy( msg.sender );
94     }
95 
96     event Buy( address _buyer, uint _tokens, uint _payedWei );
97     function buy( address recipient ) payable returns(uint){
98 
99         require( ! haltSale );
100         uint weiPayment =  msg.value ;
101         require( weiPayment > 0 );
102         raisedWei = raisedWei.add( weiPayment );
103         uint recievedTokens = weiPayment.mul( 850 );
104         assert( token.transfer( recipient, recievedTokens ) );
105         Buy( recipient, recievedTokens, weiPayment );
106         if(enableTransfer){
107             ico.transfer(msg.value);
108         }
109         return weiPayment;
110     }
111 }