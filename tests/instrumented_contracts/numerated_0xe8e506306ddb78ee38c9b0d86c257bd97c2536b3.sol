1 contract TheDAOHardForkOracle {
2     address constant WithdrawDAO = 0xbf4ed7b27f1d666546e30d74d50d173d20bca754;
3     address constant DarkDAO = 0x304a554a310c7e546dfe434669c62820b7d83490;
4 
5     // public, so accessors available
6     bool public ran;
7     bool public forked;
8     bool public notforked;
9     
10     modifier after_dao_hf_block {
11         if (block.number < 1920000) throw;
12         _
13     }
14     
15     modifier run_once {
16         if (ran) throw;
17         _
18     }
19 
20     modifier has_millions(address _addr, uint _millions) {
21         if (_addr.balance >= (_millions * 1000000 ether)) _
22     }
23 
24     // 10M ether is ~ 2M less than would be available for a short
25     // while in WithdrawDAO after the HF, but probably more than
26     // anyone is willing to drop into WithdrawDAO in Classic
27     function check_withdrawdao() internal
28         has_millions(WithdrawDAO, 10) {
29         forked = true;
30     }
31 
32     // failsafe: if the above assumption is incorrect, HF tine
33     // won't have balance in DarkDAO anyway, and Classic has a
34     // sliver of time before DarkDAO split happens
35     function check_darkdao() internal
36         has_millions(DarkDAO, 3) {
37         notforked = true;
38     }
39 
40     // running is possible only once
41     // after that the dapp can only throw
42     function ()
43         after_dao_hf_block run_once {
44         ran = true;
45 
46         check_withdrawdao();
47         check_darkdao();
48 
49         // if both flags are same, then something went wrong
50         if (forked == notforked) throw;
51     }
52 }