package com.xxl.job.admin.core.thread;

import com.xxl.job.core.util.DateUtil;
import org.junit.jupiter.api.Test;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

class JobRegistryHelperTest {

    @Test
    void start() {

        Date now = new Date();
        System.out.println(DateUtil.formatDateTime(now));

        System.out.println(DateUtil.addSeconds(now, -10));

    }
}