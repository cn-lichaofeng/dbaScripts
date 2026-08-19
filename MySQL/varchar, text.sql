-- 查看 MySQL 数据库中某个表的存储引擎和行格式
SELECT 
    table_schema,
    table_name,
    row_format,
    engine
FROM information_schema.tables
WHERE table_schema = 'cf' AND table_name = 't1';

-- 查看 MySQL 默认的page size
SHOW VARIABLES LIKE 'innodb_page_size';

--================================================================
Row_format 
Dynamic是现代默认的行格式  


if row_format == COMPACT:

    if row_size <= max_row_size:              # approximately 1/2 page
        all columns are stored in-row

    else:
        choose eligible variable-length columns
        choose the largest column(s) for off-page storage

        for each selected column:
            in-row:    768-byte prefix + 20-byte pointer
            off-page:  remaining data

        all non-selected columns remain fully in-row

        stop when row_size <= max_row_size

if row_format == DYNAMIC:

    if row_size <= max_row_size:
        all columns are stored in-row

    else:
        choose eligible variable-length columns
        choose the largest column(s) for off-page storage

        for each selected column:
            in-row:    20-byte external storage pointer
            off-page:  the entire column value

        all non-selected columns remain fully in-row

        stop when row_size <= max_row_size


if row_format == COMPRESSED:

    # ① 先按照 DYNAMIC  的规则处理大字段
    # ② 然后把整个 page 压缩
    # ③ 压缩后的 page 以 KEY_BLOCK_SIZE 为目标大小存储



--=========================================================
The maximum row size, excluding any variable-length columns that are stored off-page, 
is slightly less than half of a page for 4KB, 8KB, 16KB, and 32KB page sizes. 
For example, the maximum row size for the default innodb_page_size of 16KB is about 8000 bytes. 
However, for an InnoDB page size of 64KB, the maximum row size is approximately 16000 bytes. 

If a row is less than half a page long, all of it is stored locally within the page. 