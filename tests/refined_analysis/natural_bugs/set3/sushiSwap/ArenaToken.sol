// SPDX-License-Identifier: MIT
// Modified from https://github.com/ensdomains/governance/blob/master/contracts/ENSToken.sol
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/structs/BitMaps.sol";

import "./MerkleProof.sol";
import "../interfaces/IRevokableTokenLock.sol";

contract ArenaToken is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
    using BitMaps for BitMaps.BitMap;

    /// mint cooldown period
    uint256 public constant MIN_MINT_INTERVAL = 365 days;
    /// maximum tokens allowed per mint
    /// 10_000 = 100%
    uint256 public constant MINT_CAP = 200; // 2%

    bytes32 public merkleRoot;
    /// Proportion of airdropped tokens that are immediately claimable
    /// 10_000 = 100%
    uint256 public immutable claimableProportion;
    /// Timestamp at which tokens are no longer claimable
    uint256 public immutable claimPeriodEnds;
    /// vesting contract
    IRevokableTokenLock public tokenLock;
    BitMaps.BitMap private claimed;

    /// vesting duration
    uint256 public vestDuration;
    /// timestamp till next mint is allowed
    uint256 public nextMint;

    event MerkleRootChanged(bytes32 merkleRoot);
    event Claim(address indexed claimant, uint256 amount);
    event Vest(address indexed claimant, uint256 amount);

    /**
     * @dev Constructor.
     * @param _freeSupply The number of tokens to mint for contract deployer (then transferred to timelock controller after deployment)
     * @param _airdropSupply The number of tokens to reserve for the airdrop
     * @param _claimableProportion The value in BPS of the % of claimable vs vested
     * @param _claimPeriodEnds The timestamp at which tokens are no longer claimable
     * @param _vestDuration The token vesting duration
     */
    constructor(
        uint256 _freeSupply,
        uint256 _airdropSupply,
        uint256 _claimableProportion,
        uint256 _claimPeriodEnds,
        uint256 _vestDuration
    ) ERC20("Code4rena", "ARENA") ERC20Permit("Code4rena") {
        // TODO: Change Symbol TBD
        require(_claimableProportion <= 10_000, "claimable exceeds limit");
        require(_claimPeriodEnds > block.timestamp, "cannot have a backward time");
        _mint(msg.sender, _freeSupply);
        _mint(address(this), _airdropSupply);
        nextMint = block.timestamp + MIN_MINT_INTERVAL;
        claimableProportion = _claimableProportion;
        claimPeriodEnds = _claimPeriodEnds;
        vestDuration = _vestDuration;
    }

    /**
     * @dev set vesting contract
     * @param _tokenLock address of the vesting contract
     */
    function setTokenLock(address _tokenLock) external onlyOwner {
        require(_tokenLock != address(0), "Address cannot be 0x");
        tokenLock = IRevokableTokenLock(_tokenLock);
    }

    /**
     * @dev Claims airdropped tokens.
     * @param amount The amount of the claim being made.
     * @param merkleProof A merkle proof proving the claim is valid.
     */
    function claimTokens(uint256 amount, bytes32[] calldata merkleProof) external {
        require(block.timestamp < claimPeriodEnds, "ArenaToken: Claim period ended");
        // we don't need to check that `merkleProof` has the correct length as
        // submitting a valid partial merkle proof would require `leaf` to map
        // to an intermediate hash in the merkle tree but `leaf` uses msg.sender
        // which is 20 bytes instead of 32 bytes and can't be chosen arbitrarily
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        (bool valid, uint256 index) = MerkleProof.verify(merkleProof, merkleRoot, leaf);
        require(valid, "ArenaToken: Valid proof required.");
        require(!isClaimed(index), "ArenaToken: Tokens already claimed.");

        claimed.set(index);

        uint256 claimableAmount;
        uint256 remainingAmount;

        unchecked {
            claimableAmount = (amount * claimableProportion) / 10_000;
            remainingAmount = amount - claimableAmount;
        }

        emit Claim(msg.sender, claimableAmount);

        // transfer claimable proportion to caller
        _transfer(address(this), msg.sender, claimableAmount);
        // self-delegate if no prior delegatee was chosen
        if (delegates(msg.sender) == address(0)) {
            _delegate(msg.sender, msg.sender);
        }

        require(address(tokenLock) != address(0), "Vesting contract not initialized");
        tokenLock.setupVesting(
            msg.sender,
            block.timestamp,
            block.timestamp,
            block.timestamp + vestDuration
        );
        // approve TokenLock for token transfer
        _approve(address(this), address(tokenLock), remainingAmount);
        tokenLock.lock(msg.sender, remainingAmount);
        emit Vest(msg.sender, remainingAmount);
    }

    /**
     * @dev Allows the owner to sweep unclaimed tokens after the claim period ends.
     * @param dest The address to sweep the tokens to.
     */
    function sweep(address dest) external onlyOwner {
        require(block.timestamp >= claimPeriodEnds, "ArenaToken: Claim period not yet ended");
        _transfer(address(this), dest, balanceOf(address(this)));
    }

    /**
     * @dev Returns true if the claim at the given index in the merkle tree has already been made.
     * @param index The index into the merkle tree.
     */
    function isClaimed(uint256 index) public view returns (bool) {
        return claimed.get(index);
    }

    /**
     * @dev Sets the merkle root. Only callable if the root is not yet set.
     * @param _merkleRoot The merkle root to set.
     */
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        require(merkleRoot == bytes32(0), "ArenaToken: Merkle root already set");
        merkleRoot = _merkleRoot;
        emit MerkleRootChanged(_merkleRoot);
    }

    /**
     * @dev Mints new tokens.
     * @param dest The address to mint the new tokens to.
     * @param amount The quantity of tokens to mint.
     */
    function mint(address dest, uint256 amount) external onlyOwner {
        require(
            amount <= (totalSupply() * MINT_CAP) / 10_000,
            "ArenaToken: Mint exceeds maximum amount"
        );
        require(block.timestamp >= nextMint, "ArenaToken: Cannot mint yet");

        nextMint = block.timestamp + MIN_MINT_INTERVAL;
        _mint(dest, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
