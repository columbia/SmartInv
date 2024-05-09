1 pragma solidity ^0.4.20;
2 
3 contract Eps {  
4     uint timeout; //  PROMO CODES END August 11th 2018
5     mapping (address => address) inviter;
6     
7     function bytesToAddr (bytes b) constant returns (address)  {
8         uint result = 0;
9         for (uint i = b.length-1; i+1 > 0; i--) {
10             uint c = uint(b[i]);
11             uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
12             result += to_inc;
13         }
14         return address(result);
15     }
16     
17     function addrecruit(address _recaddress, address _invaddress) private {
18         if (inviter[_recaddress] != 0x0) {
19                 revert();
20             }
21         inviter[_recaddress] = _invaddress;
22     }
23 
24     function () external payable { // Fallback Function
25         timeout = 1533954742;
26         address recaddress = msg.sender;
27         invaddress = bytesToAddr(msg.data);
28         if (invaddress == 0x0 || invaddress == recaddress) {
29             address invaddress = 0x93D43eeFcFbE8F9e479E172ee5d92DdDd2600E3b;
30         }
31         addrecruit(recaddress, invaddress);
32         uint i=0;
33         uint amount = msg.value;
34         if (amount < 0.2 ether && now > timeout) {
35             msg.sender.transfer(msg.value);
36             revert();
37         }
38         while (i < 7) {
39             uint share = amount/2;
40             if (recaddress == 0x0) {
41                 inviter[recaddress].transfer(share);
42                 recaddress = 0x93D43eeFcFbE8F9e479E172ee5d92DdDd2600E3b;
43             }
44             inviter[recaddress].transfer(share);
45             recaddress = inviter[recaddress];
46             amount -= share;
47             i++;
48         }
49         inviter[recaddress].transfer(share);
50     }
51 }