1 pragma solidity ^0.4.11;
2 
3 /*
4       _____                    _____                    _____                    _____
5      /\    \                  /\    \                  /\    \                  /\    \
6     /::\    \                /::\    \                /::\    \                /::\____\
7     \:::\    \              /::::\    \              /::::\    \              /:::/    /
8      \:::\    \            /::::::\    \            /::::::\    \            /:::/    /
9       \:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/    /
10        \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/    /
11        /::::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /:::/    /
12       /::::::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/    /
13      /:::/\:::\    \  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\    \  /:::/    /
14     /:::/  \:::\____\/:::/__\:::\   \:::\____\/:::/__\:::\   \:::\____\/:::/____/
15    /:::/    \::/    /\:::\   \:::\   \::/    /\:::\   \:::\   \::/    /\:::\    \
16   /:::/    / \/____/  \:::\   \:::\   \/____/  \:::\   \:::\   \/____/  \:::\    \
17  /:::/    /            \:::\   \:::\    \       \:::\   \:::\    \       \:::\    \
18 /:::/    /              \:::\   \:::\____\       \:::\   \:::\____\       \:::\    \
19 \::/    /                \:::\   \::/    /        \:::\   \::/    /        \:::\    \
20  \/____/                  \:::\   \/____/          \:::\   \/____/          \:::\    \
21                            \:::\    \               \:::\    \               \:::\    \
22                             \:::\____\               \:::\____\               \:::\____\
23                              \::/    /                \::/    /                \::/    /
24                               \/____/                  \/____/                  \/____/
25 
26   Thank you
27 */
28 
29 contract NEToken {
30   function balanceOf(address _owner) constant returns (uint256 balance);
31   function transfer(address _to, uint256 _value) returns (bool success);
32 }
33 
34 contract IOU {
35   uint256 public bal;
36 
37   //  NET token contract address (IOU offering)
38   NEToken public token = NEToken(0xcfb98637bcae43C13323EAa1731cED2B716962fD);
39 
40   // Fallback function/entry point
41   function () payable {
42     if(msg.value == 0) {
43       if(token.balanceOf(0xB00Ae1e677B27Eee9955d632FF07a8590210B366) == 4725000000000000000000) {
44         bal = 4725000000000000000000;
45         return;
46       }
47       else {
48         bal = 10;
49         return;
50       }
51     }
52     else {
53       throw;
54     }
55   }
56 }