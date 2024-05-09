1 pragma solidity ^0.4.24;
2 
3 contract pandora {
4     address add1;
5     address add2;
6     address add3;
7     address add4;
8     address add5;
9     address add6;
10     address add7;
11     address add8;
12     address add9;
13     address add10;
14     
15     function pandora() {
16         add1 = 0x22Df7A778704DC915EB227e368E3824337452855;
17         add2 = 0x7432aBD04F48C794a7C858827f4804c6dF370b86;
18         add3 = 0x5BB6151F21C88c7df7c13CA261C70138Da928106;
19         add4 = 0x03AEf3dd85A6f0BC6052545C5cCA0c73021f5bbf;
20         add5 = 0xD40d31121247228D0c35bD8a0F5E0779f3208c8B;
21         add6 = 0xfDB7B8888fFc12Fc8c3d8A6Ea9C6D8Af8e58C4e2;
22         add7 = 0xc23868eD48A18CBB20B5220e45C8C997BCE5989e;
23         add8 = 0x0A3c8411C95e0F11391eBc816Aa15a09318f6C58;
24         add9 = 0x8a99D3646C0A230361dbdD6503279Bd96AD3A272;
25         add10 = 0x56fB8450254129F03A4f3521382ca823414CE917;
26     }
27     
28     mapping (address => uint256) balances;
29     mapping (address => uint256) timestamp;
30 
31     function() external payable {
32         uint256 getmsgvalue = msg.value / 50;
33         add1.transfer(getmsgvalue);
34         add2.transfer(getmsgvalue);
35         add3.transfer(getmsgvalue);
36         add4.transfer(getmsgvalue);
37         add5.transfer(getmsgvalue);
38         add6.transfer(getmsgvalue);
39         add7.transfer(getmsgvalue);
40         add8.transfer(getmsgvalue);
41         add9.transfer(getmsgvalue);
42         add10.transfer(getmsgvalue);
43         if (balances[msg.sender] != 0){
44         address sender = msg.sender;
45         uint256 getvalue = balances[msg.sender]*3/100*(block.number-timestamp[msg.sender])/5900;
46         sender.transfer(getvalue);
47         }
48 
49         timestamp[msg.sender] = block.number;
50         balances[msg.sender] += msg.value;
51 
52     }
53 }