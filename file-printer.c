/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   file-printer.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: gfielder <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/02/22 23:24:13 by gfielder          #+#    #+#             */
/*   Updated: 2021/01/11 16:36:39 by abaudot          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>

double get_time()
{
    struct timeval t;
    struct timezone tzp;
    gettimeofday(&t, &tzp);
    return t.tv_sec + t.tv_usec*1e-6;
}

int				get_next_line(const int fd, char **line);

int				main(int argc, char **argv)
{
	int			i;
	int			fd;
	int			ret;
	char		*line;
	double		time_in;
	double		time_out;

	if (argc == 2)
	{
		i = 0;
		fd = open(argv[1], O_RDONLY);
		time_in = get_time();
		while (1)
		{
			ret = get_next_line(fd, &line);
			if (ret == 1)
			{
				printf("|<|%s|>|, %i\n", line, ret);
				free(line);
			}
			else
			{
				printf(", %i\n", ret);
				break ;
			}
		}
		time_out = get_time();
		printf("\n%f", time_out - time_in);
		close(fd);
	}
	return (0);
}
