1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract Owned{
6 
7     //Address of owner
8     address Owner;
9 
10     //Add modifier
11     modifier OnlyOwner{
12         if(msg.sender != Owner){
13             throw;
14         }
15         _
16     }
17 
18     //Contruction function
19     function Owned(){
20         Owner = msg.sender;
21     }
22 
23 }
24 
25 //Ethereum Safely Transfer Contract
26 //https://github.com/etcrelay/ether-transfer
27 contract EtherTransfer is Owned{
28 
29     //"If you are good at something, never do it for free" - Joker
30     //Fee is 0.1% (it's mean you send 1 ETH fee is 0.001 ETH)
31     //Notice Fee is not include transaction fee
32     uint constant Fee = 1;
33     uint constant Decs = 1000;
34 
35     bool public IsEthereum = false; 
36 
37     //Events log
38     event ETHTransfer(address indexed From,address indexed To, uint Value);
39     event ETCReturn(address indexed Return, uint Value);
40 
41     event ETCTransfer(address indexed From,address indexed To, uint Value);
42     event ETHReturn(address indexed Return, uint Value);
43     
44     //Is Vitalik Buterin on the Fork ? >_<
45     AmIOnTheFork IsHeOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
46 
47     //Construction function
48     function EtherTransfer(){
49         IsEthereum = IsHeOnTheFork.forked();
50     }
51 
52     //Only send ETH
53     function SendETH(address ETHAddress) returns(bool){
54         uint Value = msg.value - (msg.value*Fee/Decs);
55         //It is forked chain ETH
56         if(IsEthereum && ETHAddress.send(Value)){
57             ETHTransfer(msg.sender, ETHAddress, Value);
58             return true;
59         }else if(!IsEthereum && msg.sender.send(msg.value)){
60             ETCReturn(msg.sender, msg.value);
61             return true;
62         }
63         //No ETC is trapped
64         throw;
65     }
66 
67     //Only send ETC
68     function SendETC(address ETCAddress) returns(bool){
69         uint Value = msg.value - (msg.value*Fee/Decs);
70         //It is non-forked chain ETC
71         if(!IsEthereum && ETCAddress.send(Value)){
72             ETCTransfer(msg.sender, ETCAddress, Value);
73             return true;
74         } else if(IsEthereum && msg.sender.send(msg.value)){
75             ETHReturn(msg.sender, msg.value);
76             return true;
77         }
78         //No ETH is trapped
79         throw;
80     }
81 
82     //Protect user from ETC/ETH trapped
83     function (){
84         throw;
85     }
86 
87     //I get rich lol, ez
88     function WithDraw() OnlyOwner returns(bool){
89         if(this.balance > 0 && Owner.send(this.balance)){
90             return true;
91         }
92         throw;
93     }
94 
95 }