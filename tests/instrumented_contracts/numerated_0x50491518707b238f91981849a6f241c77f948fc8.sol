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
30     //Fee is 0.05% (it's mean you send 1 ETH fee is 0.0005 ETH)
31     //Notice Fee is not include transaction fee
32     uint constant Fee = 5;
33     uint constant Decs = 10000;
34 
35     //Events log
36     event ETHTransfer(address indexed From,address indexed To, uint Value);
37     event ETCTransfer(address indexed From,address indexed To, uint Value);
38     
39     //Is Vitalik Buterin on the Fork ? >_<
40     AmIOnTheFork IsHeOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
41 
42     //Only send ETH
43     function SendETH(address ETHAddress) returns(bool){
44         uint Value = msg.value - (msg.value*Fee/Decs);
45         //It is forked chain ETH
46         if(IsHeOnTheFork.forked() && ETHAddress.send(Value)){
47             ETHTransfer(msg.sender, ETHAddress, Value);
48             return true;
49         }
50         //No ETC is trapped
51         throw;
52     }
53 
54     //Only send ETC
55     function SendETC(address ETCAddress) returns(bool){
56         uint Value = msg.value - (msg.value*Fee/Decs);
57         //It is non-forked chain ETC
58         if(!IsHeOnTheFork.forked() && ETCAddress.send(Value)){
59             ETCTransfer(msg.sender, ETCAddress, Value);
60             return true;
61         }
62         //No ETH is trapped
63         throw;
64     }
65 
66     //Protect user from ETC/ETH trapped
67     function (){
68         throw;
69     }
70 
71     //I get rich lol, ez
72     function WithDraw() OnlyOwner returns(bool){
73         if(this.balance > 0 && Owner.send(this.balance)){
74             return true;
75         }
76         throw;
77     }
78 
79 }