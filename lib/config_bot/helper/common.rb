module ConfigBot
    class Common
        @@typs = %w{ask mask yes? select multi_select enum_select multiline}
        @@converts = %w{bool date datetime file float int path range regexp string symbol}
    end
end
