defmodule EctoDripperTest do
  use ExUnit.Case, async: true
  doctest BuiltInTestQuery

  describe "[:eq_field, :==]" do
    test "creates query_eq_field/2 and returns the correct query" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.eq_field == ^\"equal\">"

      assert inspect(BuiltInTestQuery.query_eq_field("table", %{eq_field: "equal"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.eq_field == ^\"equal\">"
      assert inspect(BuiltInTestQuery.query_all("table", %{eq_field: "equal"})) == expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(BuiltInTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:neq_field, :!=]" do
    test "creates query_neq_field/2 and returns the correct query" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.neq_field != ^\"not equal\">"

      assert inspect(BuiltInTestQuery.query_neq_field("table", %{neq_field: "not equal"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.neq_field != ^\"not equal\">"

      assert inspect(BuiltInTestQuery.query_all("table", %{neq_field: "not equal"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(BuiltInTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:lt_field, :<]" do
    test "creates query_lt_field/2 and returns the correct query" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.lt_field < ^\"less than\">"

      assert inspect(BuiltInTestQuery.query_lt_field("table", %{lt_field: "less than"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.lt_field < ^\"less than\">"

      assert inspect(BuiltInTestQuery.query_all("table", %{lt_field: "less than"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(BuiltInTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:gt_field, :>]" do
    test "creates query_gt_field/2 and returns the correct query" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.gt_field > ^\"greater than\">"

      assert inspect(BuiltInTestQuery.query_gt_field("table", %{gt_field: "greater than"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query = "#Ecto.Query<from t0 in \"table\", where: t0.gt_field > ^\"greater than\">"

      assert inspect(BuiltInTestQuery.query_all("table", %{gt_field: "greater than"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(BuiltInTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:gte_field, :>=]" do
    test "creates query_gte_field/2 and returns the correct query" do
      expected_query =
        "#Ecto.Query<from t0 in \"table\", where: t0.gte_field >= ^\"greater than equal\">"

      assert inspect(
               BuiltInTestQuery.query_gte_field("table", %{gte_field: "greater than equal"})
             ) == expected_query
    end

    test "adds the query to query_all/2" do
      expected_query =
        "#Ecto.Query<from t0 in \"table\", where: t0.gte_field >= ^\"greater than equal\">"

      assert inspect(BuiltInTestQuery.query_all("table", %{gte_field: "greater than equal"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(BuiltInTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:lte_field, :<=]" do
    test "[:lte_field, :<=] creates query_lte_field/2 and returns the correct query" do
      expected_query =
        "#Ecto.Query<from t0 in \"table\", where: t0.lte_field <= ^\"less than equal\">"

      assert inspect(BuiltInTestQuery.query_lte_field("table", %{lte_field: "less than equal"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query =
        "#Ecto.Query<from t0 in \"table\", where: t0.lte_field <= ^\"less than equal\">"

      assert inspect(BuiltInTestQuery.query_all("table", %{lte_field: "less than equal"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(BuiltInTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:my_thing, :do_my_thing]" do
    test "creates query_my_thing/2 and uses the do_my_thing/2 function" do
      expected_query = inspect(CustomTestQuery.do_my_thing("table", %{my_thing: "My thing"}))

      assert inspect(CustomTestQuery.query_my_thing("table", %{my_thing: "My thing"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query = inspect(CustomTestQuery.do_my_thing("table", %{my_thing: "My thing"}))

      assert inspect(CustomTestQuery.query_all("table", %{my_thing: "My thing"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(CustomTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:another_thing, :do_another_thing, :custom_arg]" do
    test "creates query_another_thing/2 and uses custom_arg" do
      expected_query =
        inspect(CustomTestQuery.do_another_thing("table", %{custom_arg: "My thing"}))

      assert inspect(CustomTestQuery.query_another_thing("table", %{custom_arg: "My thing"})) ==
               expected_query
    end

    test "adds the query to query_all/2" do
      expected_query =
        inspect(CustomTestQuery.do_another_thing("table", %{custom_arg: "My thing"}))

      assert inspect(CustomTestQuery.query_all("table", %{custom_arg: "My thing"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(CustomTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end

  describe "[:no_arg_thing, :do_no_arg_thing]" do
    test "creates query_no_arg_thing/1 and uses the do_no_arg_thing/1 function" do
      expected_query = inspect(NoArgTestQuery.do_no_arg_thing("table"))
      assert inspect(NoArgTestQuery.query_no_arg_thing("table")) == expected_query
    end

    test "always applies the query to query_all/2" do
      expected_query = inspect(NoArgTestQuery.do_no_arg_thing("table"))
      assert inspect(NoArgTestQuery.query_all("table", %{doesnt_matter: "x"})) == expected_query
    end
  end

  describe "[:all_arg_thing, :do_all_arg_thing]" do
    test "creates query_no_arg_thing/1 and uses the do_all_arg_thing/1 function" do
      expected_query =
        inspect(AllArgTestQuery.do_all_arg_thing("table", %{something: "asdf", other: "bcd"}))

      assert inspect(
               AllArgTestQuery.query_all_arg_thing("table", %{something: "asdf", other: "bcd"})
             ) == expected_query
    end

    test "adds the query to query_all/2" do
      expected_query =
        inspect(AllArgTestQuery.do_all_arg_thing("table", %{something: "asdf", other: "bcd"}))

      assert inspect(AllArgTestQuery.query_all("table", %{something: "asdf", other: "bcd"})) ==
               expected_query
    end

    test "does not apply the query in query_all/2 if the key is not in the args" do
      expected_query = "\"table\""

      assert inspect(CustomTestQuery.query_all("table", %{not_in_there: "asdf"})) ==
               expected_query
    end
  end
end
