add_executable(run_snes_tests_1 ex1.c)
target_link_libraries(run_snes_tests_1 petsc)
ADDTEST(snes_tests_1_np1_1 1 run_snes_tests_1 output/ex1_1.out "-ksp_gmres_cgs_refinement_type refine_always ")
ADDTEST(snes_tests_1_np1_2 1 run_snes_tests_1 output/ex1_2.out "-snes_monitor_short -snes_type newtontr -ksp_gmres_cgs_refinement_type refine_always ")
ADDTEST(snes_tests_1_np1_3 1 run_snes_tests_1 output/ex1_3.out "-snes_monitor_short -mat_coloring_type sl  -snes_fd_coloring -mx 8 -my 11 -ksp_gmres_cgs_refinement_type refine_always ")
add_executable(run_snes_tests_1f ex1f.F)
set_target_properties(run_snes_tests_1f PROPERTIES LINKER_LANGUAGE Fortran) # For Intel compiler 2017.4.196
target_link_libraries(run_snes_tests_1f petsc)
ADDTEST(snes_tests_1f_np1_2 1 run_snes_tests_1f output/ex1f_2.out "-snes_monitor_short -nox -snes_fd -ksp_gmres_cgs_refinement_type refine_always ")
ADDTEST(snes_tests_1f_np1_3 1 run_snes_tests_1f output/ex1f_2.out "-snes_monitor_short -nox -snes_fd_coloring -ksp_gmres_cgs_refinement_type refine_always ")
add_executable(run_snes_tests_7 ex7.c)
target_link_libraries(run_snes_tests_7 petsc)
ADDTEST(snes_tests_7_np1_1 1 run_snes_tests_7 output/ex7_1.out "-ksp_gmres_cgs_refinement_type refine_always -snes_monitor_cancel -snes_monitor_short ")
ADDTEST(snes_tests_7_np1_2 1 run_snes_tests_7 output/ex7_1.out "-variant -ksp_gmres_cgs_refinement_type refine_always -snes_monitor_cancel -snes_monitor_short ")
add_executable(run_snes_tests_17 ex17.c)
target_link_libraries(run_snes_tests_17 petsc)
ADDTEST(snes_tests_17_np1_1 1 run_snes_tests_17 output/ex17_1.out "-snes_monitor_short ")
add_executable(run_snes_tests_69 ex69.c)
target_link_libraries(run_snes_tests_69 petsc)
ADDTEST(snes_tests_69_np1_1 1 run_snes_tests_69 output/ex69_1.out "-snes_converged_reason -ksp_converged_reason ")
ADDTEST(snes_tests_69_np1_2 1 run_snes_tests_69 output/ex69_2.out "-snes_converged_reason -ksp_converged_reason -error_in_matmult ")
ADDTEST(snes_tests_69_np1_3 1 run_snes_tests_69 output/ex69_3.out "-snes_converged_reason -ksp_converged_reason -error_in_pcapply ")
ADDTEST(snes_tests_69_np1_4 1 run_snes_tests_69 output/ex69_4.out "-snes_converged_reason -ksp_converged_reason -error_in_pcsetup ")
ADDTEST(snes_tests_69_np1_5 1 run_snes_tests_69 output/ex69_5.out "-snes_converged_reason -ksp_converged_reason -error_in_pcsetup -pc_type bjacobi ")
ADDTEST(snes_tests_69_np1_6 1 run_snes_tests_69 output/ex69_6.out "-snes_converged_reason -ksp_converged_reason -error_in_domainmf -snes_mf ")
ADDTEST(snes_tests_69_np1_7 1 run_snes_tests_69 output/ex69_7.out "-snes_converged_reason -ksp_converged_reason -error_in_domain  ")
