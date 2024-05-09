1 # @version 0.2.8
2 # @title Deposit buffered ether to Lido
3 # @license MIT
4 # @author banteg
5 
6 interface Keep3r:
7     def isKeeper(keeper: address) -> bool: nonpayable
8     def worked(keeper: address): nonpayable
9 
10 
11 interface Lido:
12     def isStopped() -> bool: view
13     def getBufferedEther() -> uint256: view
14     def depositBufferedEther(max_deposits: uint256): nonpayable
15 
16 
17 keeper: public(Keep3r)
18 lido: public(Lido)
19 paused_until: public(uint256)
20 DEPOSIT_SIZE: constant(uint256) = 32 * 10 ** 18
21 MIN_DEPOSITS: constant(uint256) = 8
22 MAX_DEPOSITS: constant(uint256) = 32
23 
24 
25 @external
26 def __init__():
27     self.keeper = Keep3r(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44)
28     self.lido = Lido(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84)
29 
30 
31 @view
32 @internal
33 def available_deposits() -> uint256:
34     if self.lido.isStopped():
35         return 0
36     if self.paused_until > block.timestamp:
37         return 0
38     return min(self.lido.getBufferedEther() / DEPOSIT_SIZE, MAX_DEPOSITS)
39 
40 
41 @view
42 @external
43 def workable() -> bool:
44     return self.available_deposits() >= MIN_DEPOSITS
45 
46 
47 @external
48 def work():
49     assert self.keeper.isKeeper(msg.sender)  # dev: not keeper
50     deposits: uint256 = self.available_deposits()
51     assert deposits >= MIN_DEPOSITS  # dev: not workable
52     buffered: uint256 = self.lido.getBufferedEther()
53     self.lido.depositBufferedEther(deposits)
54     # pause for a day if there is a key shortage
55     deposited: uint256 = buffered - self.lido.getBufferedEther()
56     if deposited < deposits * DEPOSIT_SIZE:
57         self.paused_until = block.timestamp + 86400
58     self.keeper.worked(msg.sender)