1 # @version ^0.3.3
2 
3 interface Vault():
4     def deposit(amount: uint256, recipient: address) -> uint256: nonpayable
5     def withdraw(maxShares: uint256, recipient: address, max_loss: uint256) -> uint256: nonpayable
6     def transferFrom(_from : address, _to : address, _value : uint256) -> bool: nonpayable
7     def transfer(_to : address, _value : uint256) -> bool: nonpayable
8     def token() -> address: nonpayable
9     def balanceOf(owner: address) -> uint256: view
10 
11 interface WEth(ERC20):
12     def deposit(): payable
13     def approve(_spender : address, _value : uint256) -> bool: nonpayable
14     def withdraw(amount: uint256): nonpayable
15 
16 VAULT: immutable(Vault)
17 WETH: immutable(WEth)
18 started_withdraw: bool
19 
20 @external
21 def __init__(vault: address):
22     weth: address = Vault(vault).token()
23     VAULT = Vault(vault)
24     WETH = WEth(weth)
25     WEth(weth).approve(vault, MAX_UINT256)
26     self.started_withdraw = False
27 
28 @internal
29 def _deposit(sender: address, amount: uint256):
30     assert amount != 0 #dev: "!value"
31     WETH.deposit(value= amount)
32     VAULT.deposit(amount, sender)
33 
34 @external
35 @payable
36 def deposit():
37     self._deposit(msg.sender, msg.value)
38 
39 @external
40 @nonpayable
41 def withdraw(amount: uint256, max_loss: uint256 = 1):
42     self.started_withdraw = True
43     VAULT.transferFrom(msg.sender, self, amount)
44     weth_amount: uint256 = VAULT.withdraw(amount, self, max_loss)
45     assert amount != 0 #dev: "!amount"
46     WETH.withdraw(weth_amount)
47     send(msg.sender, weth_amount)
48     left_over: uint256 = VAULT.balanceOf(self)
49     if left_over > 0:
50         VAULT.transfer(msg.sender, left_over)
51     self.started_withdraw = False
52 
53 @external
54 @payable
55 def __default__():
56     if self.started_withdraw == False:
57         self._deposit(msg.sender, msg.value)