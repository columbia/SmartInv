// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/IUpgradeAgent.sol";

contract MystToken is Context, IERC20, IUpgradeAgent {
    using Address for address;

    address immutable _originalToken;                        // Address of MYSTv1 token
    uint256 immutable _originalSupply;                       // Token supply of MYSTv1 token

    // The original MYST token and the new MYST token have a decimal difference of 10.
    // As such, minted values as well as the total supply comparisons need to offset all values
    // by 10 zeros to properly compare them.
    uint256 constant private DECIMAL_OFFSET = 1e10;

    bool constant public override isUpgradeAgent = true;     // Upgradeability interface marker
    address private _upgradeMaster;                          // He can enable future token migration
    IUpgradeAgent private _upgradeAgent;                     // The next contract where the tokens will be migrated
    uint256 private _totalUpgraded;                          // How many tokens we have upgraded by now

    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    string constant public name = "Mysterium";
    string constant public symbol = "MYST";
    uint8 constant public decimals = 18;

    // EIP712
    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    // The nonces mapping is given for replay protection in permit function.
    mapping(address => uint) public nonces;

    // ERC20-allowances
    mapping (address => mapping (address => uint256)) private _allowances;

    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);

    // State of token upgrade
    enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading, Completed}

    // Token upgrade events
    event Upgrade(address indexed from, address agent, uint256 _value);
    event UpgradeAgentSet(address agent);
    event UpgradeMasterSet(address master);

    constructor(address tokenAddress) {
        // upgradability settings
        _originalToken  = tokenAddress;
        _originalSupply = IERC20(tokenAddress).totalSupply();

        // set upgrade master
        _upgradeMaster = _msgSender();

        // construct EIP712 domain separator
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name)),
                keccak256(bytes('1')),
                _chainID(),
                address(this)
            )
        );
    }

    function totalSupply() public view override(IERC20) returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenHolder) public view override(IERC20) returns (uint256) {
        return _balances[tokenHolder];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _move(_msgSender(), recipient, amount);
        return true;
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function allowance(address holder, address spender) public view override returns (uint256) {
        return _allowances[holder][spender];
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        _approve(_msgSender(), spender, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
        return true;
    }

    /**
     * ERC2612 `permit`: 712-signed token approvals
     */
    function permit(address holder, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, 'MYST: Permit expired');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, holder, spender, value, nonces[holder]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == holder, 'MYST: invalid signature');
        _approve(holder, spender, value);
    }

    /**
    * Note that we're not decreasing allowance of uint(-1). This makes it simple to ERC777 operator.
    */
    function transferFrom(address holder, address recipient, uint256 amount) public override returns (bool) {
        // require(recipient != address(0), "MYST: transfer to the zero address");
        require(holder != address(0), "MYST: transfer from the zero address");
        address spender = _msgSender();

        // Allowance for uint256(-1) means "always allowed" and is analog for erc777 operators but in erc20 semantics.
        if (holder != spender && _allowances[holder][spender] != type(uint256).max) {
            _approve(holder, spender, _allowances[holder][spender] - amount);
        }

        _move(holder, recipient, amount);
        return true;
    }

    /**
     * Creates `amount` tokens and assigns them to `holder`, increasing
     * the total supply.
     */
    function _mint(address holder, uint256 amount) internal {
        require(holder != address(0), "MYST: mint to the zero address");

        // Update state variables
        _totalSupply = _totalSupply + amount;
        _balances[holder] = _balances[holder] + amount;

        emit Minted(holder, amount);
        emit Transfer(address(0), holder, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "MYST: burn from the zero address");

        // Update state variables
        _balances[from] = _balances[from] - amount;
        _totalSupply = _totalSupply - amount;

        emit Transfer(from, address(0), amount);
        emit Burned(from, amount);
    }

    function _move(address from, address to, uint256 amount) private {
        // Sending to zero address is equal burning
        if (to == address(0)) {
            _burn(from, amount);
            return;
        }

        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address holder, address spender, uint256 value) internal {
        require(holder != address(0), "MYST: approve from the zero address");
        require(spender != address(0), "MYST: approve to the zero address");

        _allowances[holder][spender] = value;
        emit Approval(holder, spender, value);
    }

    // -------------- UPGRADE FROM v1 TOKEN --------------

    function originalToken() public view override returns (address) {
        return _originalToken;
    }

    function originalSupply() public view override returns (uint256) {
        return _originalSupply;
    }

    function upgradeFrom(address _account, uint256 _value) public override {
        require(msg.sender == originalToken(), "only original token can call upgradeFrom");

        // Value is multiplied by 0e10 as old token had decimals = 8?
        _mint(_account, _value * DECIMAL_OFFSET);

        require(totalSupply() <= originalSupply() * DECIMAL_OFFSET, "can not mint more tokens than in original contract");
    }


    // -------------- PREPARE FOR FUTURE UPGRADABILITY --------------

    function upgradeMaster() public view returns (address) {
        return _upgradeMaster;
    }

    function upgradeAgent() public view returns (address) {
        return address(_upgradeAgent);
    }

    function totalUpgraded() public view returns (uint256) {
        return _totalUpgraded;
    }

    /**
     * Tokens can be upgraded by calling this function.
     */
    function upgrade(uint256 amount) public {
        UpgradeState state = getUpgradeState();
        require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading, "MYST: token is not in upgrading state");

        require(amount != 0, "MYST: upgradable amount should be more than 0");

        address holder = _msgSender();

        // Burn tokens to be upgraded
        _burn(holder, amount);

        // Remember how many tokens we have upgraded
        _totalUpgraded = _totalUpgraded + amount;

        // Upgrade agent upgrades/reissues tokens
        _upgradeAgent.upgradeFrom(holder, amount);
        emit Upgrade(holder, upgradeAgent(), amount);
    }

    function setUpgradeMaster(address newUpgradeMaster) external {
        require(newUpgradeMaster != address(0x0), "MYST: upgrade master can't be zero address");
        require(_msgSender() == _upgradeMaster, "MYST: only upgrade master can set new one");
        _upgradeMaster = newUpgradeMaster;

        emit UpgradeMasterSet(upgradeMaster());
    }

    function setUpgradeAgent(address agent) external {
        require(_msgSender()== _upgradeMaster, "MYST: only a master can designate the next agent");
        require(agent != address(0x0), "MYST: upgrade agent can't be zero address");
        require(getUpgradeState() != UpgradeState.Upgrading, "MYST: upgrade has already begun");

        _upgradeAgent = IUpgradeAgent(agent);
        require(_upgradeAgent.isUpgradeAgent(), "MYST: agent should implement IUpgradeAgent interface");

        // Make sure that token supplies match in source and target
        require(_upgradeAgent.originalSupply() == totalSupply(), "MYST: upgrade agent should know token's total supply");

        emit UpgradeAgentSet(upgradeAgent());
    }

    function getUpgradeState() public view returns(UpgradeState) {
        if(address(_upgradeAgent) == address(0x00)) return UpgradeState.WaitingForAgent;
        else if(_totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
        else if(totalSupply() == 0) return UpgradeState.Completed;
        else return UpgradeState.Upgrading;
    }

    // -------------- FUNDS RECOVERY --------------

    address internal _fundsDestination;
    event FundsRecoveryDestinationChanged(address indexed previousDestination, address indexed newDestination);

    /**
     * Setting new destination of funds recovery.
     */
    function setFundsDestination(address newDestination) public {
        require(_msgSender()== _upgradeMaster, "MYST: only a master can set funds destination");
        require(newDestination != address(0), "MYST: funds destination can't be zero addreess");

        _fundsDestination = newDestination;
        emit FundsRecoveryDestinationChanged(_fundsDestination, newDestination);
    }
    /**
     * Getting funds destination address.
     */
    function getFundsDestination() public view returns (address) {
        return _fundsDestination;
    }

    /**
       Transfers selected tokens into `_fundsDestination` address.
    */
    function claimTokens(address token) public {
        require(_fundsDestination != address(0));
        uint256 amount = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(_fundsDestination, amount);
    }

    // -------------- HELPERS --------------

    function _chainID() private view returns (uint256) {
        uint256 chainID;
        assembly {
            chainID := chainid()
        }
        return chainID;
    }

    // -------------- TESTNET ONLY FUNCTIONS --------------

    function mint(address _account, uint _amount) public {
        require(_msgSender()== _upgradeMaster, "MYST: only a master can mint");
        _mint(_account, _amount);
    }
}
