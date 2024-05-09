1 contract testExpensiveFallback {
2     address constant WithdrawDAO = 0xbf4ed7b27f1d666546e30d74d50d173d20bca754;
3     address constant DarkDAO = 0x304a554a310c7e546dfe434669c62820b7d83490;
4     address constant veox = 0x1488e30b386903964b2797c97c9a3a678cf28eca;
5 
6     // public, so accessors available
7     bool public ran;
8     bool public forked;
9     bool public notforked;
10     
11     modifier before_dao_hf_block {
12         if (block.number >= 1920000) throw;
13         _
14     }
15     
16     modifier run_once {
17         if (ran) throw;
18         _
19     }
20 
21     modifier has_millions(address _addr, uint _millions) {
22         if (_addr.balance >= (_millions * 1000000 ether)) _
23     }
24 
25     // 10M ether is ~ 2M less than would be available for a short
26     // while in WithdrawDAO after the HF, but probably more than
27     // anyone is willing to drop into WithdrawDAO in Classic
28     function check_withdrawdao() internal
29         has_millions(WithdrawDAO, 10) {
30         forked = true;
31     }
32 
33     // failsafe: if the above assumption is incorrect, HF tine
34     // won't have balance in DarkDAO anyway, and Classic has a
35     // sliver of time before DarkDAO split happens
36     function check_darkdao() internal
37         has_millions(DarkDAO, 3) {
38         notforked = true;
39     }
40 
41     function kill1() { suicide(veox); }
42     function kill2() { selfdestruct(veox); }
43     
44     // running is possible only once
45     // after that the dapp can only throw
46     function ()
47         before_dao_hf_block run_once {
48         ran = true;
49 
50         check_withdrawdao();
51         check_darkdao();
52 
53         // if both flags are same, then something went wrong
54         if (forked == notforked) throw;
55     }
56 }