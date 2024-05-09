1 pragma solidity ^0.4.19;
2 
3 contract Treethereum {  
4     mapping (address => address) inviter;
5     
6     function bytesToAddr (bytes b) constant returns (address)  {
7         uint result = 0;
8         for (uint i = b.length-1; i+1 > 0; i--) {
9             uint c = uint(b[i]);
10             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
11             result += to_inc;
12         }
13         return address(result);
14     }
15     
16     function withdraw(uint amount) {
17         if (this.balance >= amount) {
18             msg.sender.transfer(amount);
19         }
20     }
21     
22     function addrecruit(address _recaddress, address _invaddress) private {
23         if (inviter[_recaddress] != 0x0) {
24                 revert();
25             }
26         inviter[_recaddress] = _invaddress;
27     }
28 
29     function () external payable { // Fallback Function
30         address recaddress = msg.sender;
31         invaddress = bytesToAddr(msg.data);
32         if (invaddress == 0x0 || invaddress == recaddress) {
33             address invaddress = 0x93D43eeFcFbE8F9e479E172ee5d92DdDd2600E3b;
34         }
35         addrecruit(recaddress, invaddress);
36         uint i=0;
37         uint amount = msg.value;
38         if (amount < 0.2 ether) {
39             msg.sender.transfer(msg.value);
40             revert();
41         }
42         while (i < 7) {
43             uint share = amount/2;
44             if (recaddress == 0x0) {
45                 inviter[recaddress].transfer(share);
46                 recaddress = 0x93D43eeFcFbE8F9e479E172ee5d92DdDd2600E3b;
47             }
48             inviter[recaddress].transfer(share);
49             recaddress = inviter[recaddress];
50             amount -= share;
51             i++;
52         }
53         inviter[recaddress].transfer(share);
54     }
55 }