DROP TABLE IF EXISTS xxl_job_group;
CREATE TABLE xxl_job_group(
    id SERIAL NOT NULL,
    app_name VARCHAR(128) NOT NULL,
    title VARCHAR(255) NOT NULL,
    address_type TINYINT NOT NULL DEFAULT  0,
    address_list VARCHAR(512),
    update_time timestamp,
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_group IS '';
COMMENT ON COLUMN xxl_job_group.app_name IS '执行器AppName';
COMMENT ON COLUMN xxl_job_group.title IS '执行器名称';
COMMENT ON COLUMN xxl_job_group.address_type IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN xxl_job_group.address_list IS '执行器地址列表，多地址逗号分隔';

DROP TABLE IF EXISTS xxl_job_info;
CREATE TABLE xxl_job_info(
    id SERIAL NOT NULL,
    job_group INT NOT NULL,
    job_cron VARCHAR(128),
    job_desc VARCHAR(255) NOT NULL,
    add_time timestamp,
    update_time timestamp,
    author VARCHAR(64),
    alarm_email VARCHAR(255),
    executor_route_strategy VARCHAR(50),
    executor_handler VARCHAR(255),
    executor_param VARCHAR(512),
    executor_block_strategy VARCHAR(50),
    executor_timeout INT NOT NULL DEFAULT  0,
    executor_fail_retry_count INT NOT NULL DEFAULT  0,
    glue_type VARCHAR(50) NOT NULL,
    glue_source TEXT,
    glue_remark VARCHAR(128),
    glue_updatetime timestamp,
    child_jobid VARCHAR(255),
    trigger_status TINYINT NOT NULL DEFAULT  0,
    trigger_last_time BIGINT NOT NULL DEFAULT  0,
    trigger_next_time BIGINT NOT NULL DEFAULT  0,
    schedule_type VARCHAR(255),
    schedule_conf VARCHAR(255),
    misfire_strategy VARCHAR(255),
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_info IS '';
COMMENT ON COLUMN xxl_job_info.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_info.job_cron IS '任务执行CRON';
COMMENT ON COLUMN xxl_job_info.author IS '作者';
COMMENT ON COLUMN xxl_job_info.alarm_email IS '报警邮件';
COMMENT ON COLUMN xxl_job_info.executor_route_strategy IS '执行器路由策略';
COMMENT ON COLUMN xxl_job_info.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_info.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_info.executor_block_strategy IS '阻塞处理策略';
COMMENT ON COLUMN xxl_job_info.executor_timeout IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN xxl_job_info.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_info.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_info.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_info.glue_remark IS 'GLUE备注';
COMMENT ON COLUMN xxl_job_info.glue_updatetime IS 'GLUE更新时间';
COMMENT ON COLUMN xxl_job_info.child_jobid IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN xxl_job_info.trigger_status IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN xxl_job_info.trigger_last_time IS '上次调度时间';
COMMENT ON COLUMN xxl_job_info.trigger_next_time IS '下次调度时间';

DROP TABLE IF EXISTS xxl_job_lock;
CREATE TABLE xxl_job_lock(
    lock_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (lock_name)
);

COMMENT ON TABLE xxl_job_lock IS '';
COMMENT ON COLUMN xxl_job_lock.lock_name IS '锁名称';

DROP TABLE IF EXISTS xxl_job_log;
CREATE TABLE xxl_job_log(
    id SERIAL NOT NULL,
    job_group INT NOT NULL,
    job_id INT NOT NULL,
    executor_address VARCHAR(255),
    executor_handler VARCHAR(255),
    executor_param VARCHAR(512),
    executor_sharding_param VARCHAR(20),
    executor_fail_retry_count INT NOT NULL DEFAULT  0,
    trigger_time timestamp,
    trigger_code INT NOT NULL,
    trigger_msg TEXT,
    handle_time timestamp,
    handle_code INT NOT NULL,
    handle_msg TEXT,
    alarm_status INT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_log IS '';
COMMENT ON COLUMN xxl_job_log.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_log.job_id IS '任务，主键ID';
COMMENT ON COLUMN xxl_job_log.executor_address IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN xxl_job_log.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_log.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_log.executor_sharding_param IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN xxl_job_log.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_log.trigger_time IS '调度-时间';
COMMENT ON COLUMN xxl_job_log.trigger_code IS '调度-结果';
COMMENT ON COLUMN xxl_job_log.trigger_msg IS '调度-日志';
COMMENT ON COLUMN xxl_job_log.handle_time IS '执行-时间';
COMMENT ON COLUMN xxl_job_log.handle_code IS '执行-状态';
COMMENT ON COLUMN xxl_job_log.handle_msg IS '执行-日志';
COMMENT ON COLUMN xxl_job_log.alarm_status IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';


CREATE INDEX I_handle_code ON xxl_job_log(handle_code);
CREATE INDEX I_trigger_time ON xxl_job_log(trigger_time);

DROP TABLE IF EXISTS xxl_job_log_report;
CREATE TABLE xxl_job_log_report(
    id SERIAL NOT NULL,
    trigger_day timestamp,
    running_count INT NOT NULL DEFAULT  0,
    suc_count INT NOT NULL DEFAULT  0,
    fail_count INT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_log_report IS '';
COMMENT ON COLUMN xxl_job_log_report.trigger_day IS '调度-时间';
COMMENT ON COLUMN xxl_job_log_report.running_count IS '运行中-日志数量';
COMMENT ON COLUMN xxl_job_log_report.suc_count IS '执行成功-日志数量';
COMMENT ON COLUMN xxl_job_log_report.fail_count IS '执行失败-日志数量';


CREATE UNIQUE INDEX i_trigger_day ON xxl_job_log_report(trigger_day);

DROP TABLE IF EXISTS xxl_job_logglue;
CREATE TABLE xxl_job_logglue(
    id SERIAL NOT NULL,
    job_id INT NOT NULL,
    glue_type VARCHAR(50),
    glue_source TEXT,
    glue_remark VARCHAR(128) NOT NULL,
    add_time timestamp,
    update_time timestamp,
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_logglue IS '';
COMMENT ON COLUMN xxl_job_logglue.job_id IS '任务，主键ID';
COMMENT ON COLUMN xxl_job_logglue.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_logglue.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_logglue.glue_remark IS 'GLUE备注';

DROP TABLE IF EXISTS xxl_job_registry;
CREATE TABLE xxl_job_registry(
    id SERIAL NOT NULL,
    registry_group VARCHAR(50) NOT NULL,
    registry_key VARCHAR(255) NOT NULL,
    registry_value VARCHAR(255) NOT NULL,
    update_time timestamp,
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_registry IS '';


CREATE INDEX i_g_k_v ON xxl_job_registry(registry_group,registry_key,registry_value);

DROP TABLE IF EXISTS xxl_job_user;
CREATE TABLE xxl_job_user(
    id SERIAL NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    role TINYINT NOT NULL,
    permission VARCHAR(255),
    PRIMARY KEY (id)
);

COMMENT ON TABLE xxl_job_user IS '';
COMMENT ON COLUMN xxl_job_user.username IS '账号';
COMMENT ON COLUMN xxl_job_user.password IS '密码';
COMMENT ON COLUMN xxl_job_user.role IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN xxl_job_user.permission IS '权限：执行器ID列表，多个逗号分割';


CREATE UNIQUE INDEX i_username ON xxl_job_user(username);

INSERT INTO xxl_job_group(id, app_name, title, address_type, address_list, update_time) VALUES (1, 'xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31' );
INSERT INTO xxl_job_info(id, job_group, job_desc, add_time, update_time, author, alarm_email, schedule_type, schedule_conf, misfire_strategy, executor_route_strategy, executor_handler, executor_param, executor_block_strategy, executor_timeout, executor_fail_retry_count, glue_type, glue_source, glue_remark, glue_updatetime, child_jobid) VALUES (1, 1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *', 'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', '2018-11-03 22:21:31', '');
INSERT INTO xxl_job_user(id, username, password, role, permission) VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO xxl_job_lock ( lock_name) VALUES ( 'schedule_lock');

