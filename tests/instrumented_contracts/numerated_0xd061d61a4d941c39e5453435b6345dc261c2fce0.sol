1 # @version 0.2.4
2 """
3 @title Token Minter
4 @author Curve Finance
5 @license MIT
6 """
7 
8 interface LiquidityGauge:
9     # Presumably, other gauges will provide the same interfaces
10     def integrate_fraction(addr: address) -> uint256: view
11     def user_checkpoint(addr: address) -> bool: nonpayable
12 
13 interface MERC20:
14     def mint(_to: address, _value: uint256) -> bool: nonpayable
15 
16 interface GaugeController:
17     def gauge_types(addr: address) -> int128: view
18 
19 
20 event Minted:
21     recipient: indexed(address)
22     gauge: address
23     minted: uint256
24 
25 
26 token: public(address)
27 controller: public(address)
28 
29 # user -> gauge -> value
30 minted: public(HashMap[address, HashMap[address, uint256]])
31 
32 # minter -> user -> can mint?
33 allowed_to_mint_for: public(HashMap[address, HashMap[address, bool]])
34 
35 
36 @external
37 def __init__(_token: address, _controller: address):
38     self.token = _token
39     self.controller = _controller
40 
41 
42 @internal
43 def _mint_for(gauge_addr: address, _for: address):
44     assert GaugeController(self.controller).gauge_types(gauge_addr) >= 0  # dev: gauge is not added
45 
46     LiquidityGauge(gauge_addr).user_checkpoint(_for)
47     total_mint: uint256 = LiquidityGauge(gauge_addr).integrate_fraction(_for)
48     to_mint: uint256 = total_mint - self.minted[_for][gauge_addr]
49 
50     if to_mint != 0:
51         MERC20(self.token).mint(_for, to_mint)
52         self.minted[_for][gauge_addr] = total_mint
53 
54         log Minted(_for, gauge_addr, total_mint)
55 
56 
57 @external
58 @nonreentrant('lock')
59 def mint(gauge_addr: address):
60     """
61     @notice Mint everything which belongs to `msg.sender` and send to them
62     @param gauge_addr `LiquidityGauge` address to get mintable amount from
63     """
64     self._mint_for(gauge_addr, msg.sender)
65 
66 
67 @external
68 @nonreentrant('lock')
69 def mint_many(gauge_addrs: address[8]):
70     """
71     @notice Mint everything which belongs to `msg.sender` across multiple gauges
72     @param gauge_addrs List of `LiquidityGauge` addresses
73     """
74     for i in range(8):
75         if gauge_addrs[i] == ZERO_ADDRESS:
76             break
77         self._mint_for(gauge_addrs[i], msg.sender)
78 
79 
80 @external
81 @nonreentrant('lock')
82 def mint_for(gauge_addr: address, _for: address):
83     """
84     @notice Mint tokens for `_for`
85     @dev Only possible when `msg.sender` has been approved via `toggle_approve_mint`
86     @param gauge_addr `LiquidityGauge` address to get mintable amount from
87     @param _for Address to mint to
88     """
89     if self.allowed_to_mint_for[msg.sender][_for]:
90         self._mint_for(gauge_addr, _for)
91 
92 
93 @external
94 def toggle_approve_mint(minting_user: address):
95     """
96     @notice allow `minting_user` to mint for `msg.sender`
97     @param minting_user Address to toggle permission for
98     """
99     self.allowed_to_mint_for[minting_user][msg.sender] = not self.allowed_to_mint_for[minting_user][msg.sender]